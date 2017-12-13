imwidth = 400;
imheight = 400;
x1 = linspace(-1.5,1.5, imwidth+1);
y1 = linspace(complex(0,-1.5),complex(0,1.5), imheight+1);
coords=x1+y1';
%coords=coords-1+1i;

roots=zeros(imwidth+1, imheight+1);
iterations=zeros(imwidth+1, imheight+1);

%% Parameter for Newtons Method:
f = 'z^3-1';
df = '3*z^2';

parfor (idx = 1:numel(coords), 12)
    x0 = coords(idx);
    res = newton( f, df, x0, 0.5*10^-10, 50 );
    roots(idx) = res(end);
    iterations(idx) = length(res);
    if mod(idx, 100) == 0
        idx
    end
end

R = round(real(roots),1) < 0;
G = round(real(roots),1) > 0;
B = round(real(roots),1) == 0;
im = cat(3, R, G, B);
imwrite(im, 'colored.jpg', 'jpg');
% [x, ex] = arrayfun(@(x) newton( 'x^3-1', '2*x^2', x, 0.5*10^-8, 100 ), coords, 'un', 0);

imiterations = (iterations./30);
imwrite(imiterations, 'it_colored.jpg', 'jpg');

imiterations_rev = 1.3 - imiterations;
imwrite(imiterations_rev, 'it_colored2.jpg', 'jpg');

im_shaded = im .* imiterations_rev;
imwrite(im_shaded, 'it_reversed_colored.jpg', 'jpg');

Rit = zeros(imwidth+1, imheight+1);
Git = iterations <= 20;
Bit = 20 < iterations;
imit = cat(3, Rit, Git, Bit); 
imwrite(imit, 'sin5.jpg', 'jpg');