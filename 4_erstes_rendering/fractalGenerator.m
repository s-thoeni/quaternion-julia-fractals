function resimage = fractalGenerator(cx,cy,cz,cw)
% Load the kernel
close all;
cudaFilename = 'processQuatJulEle.cu';
ptxFilename = ['processQuatJulEle.ptx'];
kernel = parallel.gpu.CUDAKernel( ptxFilename, cudaFilename );

maxIterations = 50;
gridSize = 400;
xlim = [-1.5, 1.5];
ylim = [-1.5, 1.5];
zlim = [-1.5, 1.5];
wlim = [-1.5, 1.5];
gpuEnabled = 0;

% Setup
t = tic();

x = gpuArray.linspace( xlim(1), xlim(2), gridSize );
y = gpuArray.linspace( ylim(1), ylim(2), gridSize );
z = gpuArray.linspace( ylim(1), ylim(2), gridSize );    

[xGrid, yGrid, zGrid] = meshgrid(x, y, z);
wGrid = zeros(gridSize, gridSize, gridSize);
%q0 = cat(4, xGrid, yGrid, zGrid, wGrid);

% Make sure we have sufficient blocks to cover all of the locations
numElements = numel( xGrid );
kernel.ThreadBlockSize = [kernel.MaxThreadsPerBlock,1,1];
kernel.GridSize = [ceil(numElements/kernel.MaxThreadsPerBlock),1];

count = zeros( size(xGrid), 'gpuArray' );

% Calculate
count = feval( kernel, count, xGrid, yGrid, zGrid, wGrid, cx, cy, cz, cw, maxIterations, numElements );

% Show
count = gather( count ); % Fetch the data back from the GPU

ax = gca;
ax.Visible = 'off';
pbaspect([1 1 1]);

view(-30,0)
lighting gouraud
lightangle(45,30);

iso = patch(isosurface(count, 30),...
'FaceColor',[0.11,.66,.78],...
'EdgeColor','none');


%lighting phong
F = getframe(gcf);
resimage = F.cdata;
hold off
end