function generateHighResolutionFractal(cx, cy, cz, cw, filename)
% GENERATEHIGHRESOLUTIONFRACTAL    Generates a fractal with 8x higher
% resolution than createFractal. It calls createFractal for 8x smaller
% cubes and sets them together. This was necessary because the memory on
% the GPU was not sufficient.

% specify sample size
sampleSize = 400;
% specify limits (sampling space)
xlim = linspace(-1.5, 1.5, 3);
ylim = linspace(-1.5, 1.5, 3);
zlim = linspace(-1.5, 1.5, 3);
wlim = [-1.5 1.5];

% cx = -0.218;
% cy = -0.113;
% cz = -0.181;
% cw = -0.496;

linux = false;
% createFractal is called for 8 sub-cubes and then patched together using
% cat

% front, bottom, left cube
fbl = createFractal(cx,cy,cz,cw, xlim(1:2), ylim(1:2), zlim(1:2), wlim, sampleSize, linux);
% front, bottom, right cube
fbr = createFractal(cx,cy,cz,cw, xlim(2:3), ylim(1:2), zlim(1:2), wlim, sampleSize, linux);
% cat fbl and fbr together to get front-bottom element
fb = cat(2, fbl, fbr);

% bottom back left cube
bbl = createFractal(cx,cy,cz,cw, xlim(1:2), ylim(2:3), zlim(1:2), wlim, sampleSize, linux);
% bottom back right cube
bbr = createFractal(cx,cy,cz,cw, xlim(2:3), ylim(2:3), zlim(1:2), wlim, sampleSize, linux);
% bbl and bbr concatenated results in bottom back element
bb = cat(2, bbl, bbr);
% fb and bb concatenated results in the bottom plane of the cube
bottom = cat(1,fb,bb);

ftl = createFractal(cx,cy,cz,cw, xlim(1:2), ylim(1:2), zlim(2:3), wlim, sampleSize, linux);
ftr = createFractal(cx,cy,cz,cw, xlim(2:3), ylim(1:2), zlim(2:3), wlim, sampleSize, linux);
ft = cat(2, ftl, ftr);

btl = createFractal(cx,cy,cz,cw, xlim(1:2), ylim(2:3), zlim(2:3), wlim, sampleSize, linux);
btr = createFractal(cx,cy,cz,cw, xlim(2:3), ylim(2:3), zlim(2:3), wlim, sampleSize, linux);
bt = cat(2, btl, btr);
top = cat(1, ft,bt);

% the bottom and top concateneted gives the result
result = cat(3, bottom, top);

% create isosurface and call render
render(isosurface(result,12), filename);
%count = cat(1, count, reshape(createFractalCnt(cx,cy,cz,cw, xlim(2:3), ylim(1:2), zlim(1:2), wlim, sampleSize), [], 1));
%render(isosurface(reshape(count, [800,400,400]), 30));

end