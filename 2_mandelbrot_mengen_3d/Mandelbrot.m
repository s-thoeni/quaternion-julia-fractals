
%count = csvread("count.csv");

%c = reshape(count,[410 410 410]);

% hold on
% for idx = 1:numel(c(1,1,:))
%  surf(c(:,:,idx));
%  pause(0.01);
% end

% test =        [1 2 3; 4 5 6; 7 8 9];
% test(:,:,2) = [10 11 12; 13 14 15; 16 17 18];
% test(:,:,3) = [19 20 21; 22 23 24; 25 26 27];
% 
% [row,col] = find(c>30);
% 
% X=row;
% Y=mod(col,size(c,1));
% Y(~Y)=3;
% Z=ceil(col/size(c,1));

%plot3(X, Y, Z, 'p');
%scatter3(X,Y,Z,'filled');
c1=c;

% cut mandelbrot in half
%c1(:,:,205:410)=0;

hiso = patch(isosurface(c1, 30), 'FaceColor', [200/255, 1, 1], 'EdgeColor', 'none');

view(35,30)
lightangle(45,30)
lighting phong
set(gca,'xtick',[],'ytick',[],'ztick',[]);
xlabel('y');
ylabel('x');
zlabel('z');

