function count = createFractal(cx,cy,cz,cw, xlim, ylim, zlim, wlim, sampleSize, linux)
% CREATEFRACTAL   Create a julia fractal for given c values
%       count = CREATEFRACTAL(cx,cy,cz,cw, xlim, ylim, zlim, wlim,
%       sampleSize, linux) cx,cy,cz,cw are the constant c for the function
%       f(x)= x^2 + c that will be iterated over. 
%       xlim, ylim, zlim, wlim - limits the space for which will be
%       iterated
%       sampleSize - specifies the sampling rate (i.e. the number of pixels
%       used). 
%       linux - set to 1 if programm is run on a linux operating system


% Load the kernel depending on the operating system
if linux
    cudaFilename = 'processQuatJulEle_linux.cu';
    ptxFilename = ['processQuatJulEle_linux.ptx'];
else
    cudaFilename = 'processQuatJulEle.cu';
    ptxFilename = ['processQuatJulEle.ptx'];
end
    
kernel = parallel.gpu.CUDAKernel( ptxFilename, cudaFilename );

% Amount of iterations done before deciding whether the point converges or
% diverges
maxIterations = 50;
gridSize = sampleSize;

% create a evenly spaced vector for the space that we want to sample
x = gpuArray.linspace( xlim(1), xlim(2), gridSize );
y = gpuArray.linspace( ylim(1), ylim(2), gridSize );
z = gpuArray.linspace( zlim(1), zlim(2), gridSize );    

% Create a coordinate cube from the sample-space
[xGrid, yGrid, zGrid] = meshgrid(x, y, z);

% set the w component all to zero. This is a kind of dimension reduction.
wGrid = zeros(gridSize, gridSize, gridSize);
%q0 = cat(4, xGrid, yGrid, zGrid, wGrid);

% Initialize memory on gpu and define blocksizes
numElements = numel( xGrid );
kernel.ThreadBlockSize = [kernel.MaxThreadsPerBlock,1,1];
kernel.GridSize = [ceil(numElements/kernel.MaxThreadsPerBlock),1];

% The result from our calculations will be saved here
count = zeros( size(xGrid), 'gpuArray' );

% Call the kernel and iterate on gpu
count = feval( kernel, count, xGrid, yGrid, zGrid, wGrid, cx, cy, cz, cw, maxIterations, numElements );

% Gather the result from the GPU memory
count = gather( count );
end