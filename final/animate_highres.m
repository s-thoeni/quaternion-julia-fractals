frames = 101;
citx = linspace(-1.5, -0.5, frames);
city = linspace(-0.5, 0.9, frames);


for f = 1:frames    
   generateHighResolutionFractal(citx(f), city(f), 0, 0, ['test_-1,0.2,0,0/im_' num2str(f,'%02d') '.png']);
   clear createFractalCnt;clear test_highres;
end