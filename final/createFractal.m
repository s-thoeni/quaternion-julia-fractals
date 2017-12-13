function count = createFractal(cx,cy,cz,cw, xlim, ylim, zlim, wlim, sampleSize, linux)
% Load the kernel
if linux
    cudaFilename = 'processQuatJulEle_linux.cu';
    ptxFilename = ['processQuatJulEle_linux.ptx'];
else
    cudaFilename = 'processQuatJulEle.cu';
    ptxFilename = ['processQuatJulEle.ptx'];
end
    
kernel = parallel.gpu.CUDAKernel( ptxFilename, cudaFilename );

maxIterations = 50;
gridSize = sampleSize;

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

count = zeros( size(xGrid), 'gpuArray' );

% Calculate
count = feval( kernel, count, xGrid, yGrid, zGrid, wGrid, cx, cy, cz, cw, maxIterations, numElements );

%count = log( count );

% Show
count = gather( count ); % Fetch the data back from the GPU

iso = isosurface(count, 30);
end