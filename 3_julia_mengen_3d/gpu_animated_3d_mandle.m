% Load the kernel
cudaFilename = 'processQuatJulEle.cu';
ptxFilename = ['processQuatJulEle.ptx'];
kernel = parallel.gpu.CUDAKernel( ptxFilename, cudaFilename );

maxIterations = 100;
gridSize = 410;
xlim = [-1.5, 1.5];
ylim = [-1.5, 1.5];
zlim = [-1.5,1.5];
wlim = [-1.5,1.5];
gpuEnabled = 0;

% Setup
t = tic();

x = gpuArray.linspace( xlim(1), xlim(2), gridSize );
y = gpuArray.linspace( ylim(1), ylim(2), gridSize );
z = gpuArray.linspace( zlim(1), zlim(2), gridSize );    

[xGrid, yGrid, zGrid] = meshgrid(x, y, z);
wGrid = zeros(gridSize, gridSize, gridSize);
%q0 = cat(4, xGrid, yGrid, zGrid, wGrid);

% Make sure we have sufficient blocks to cover all of the locations
numElements = numel( xGrid );
kernel.ThreadBlockSize = [kernel.MaxThreadsPerBlock,1,1];
kernel.GridSize = [ceil(numElements/kernel.MaxThreadsPerBlock),1];

count = ones( size(xGrid), 'gpuArray' );

% Calculate
count = feval( kernel, count, xGrid, yGrid, zGrid, wGrid, -0.2, .8, 0, 0, maxIterations, numElements );

%count = log( count );

% Show
count = gather( count ); % Fetch the data back from the GPU

hold on
for idx = 1:numel(count(1,1,:))
 image(count(:,:,idx));
 pause(0.05);
end
time = toc( t )
%fig = gcf;
%fig.Position = [200 200 600 600];







