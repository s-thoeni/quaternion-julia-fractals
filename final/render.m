function render(fract, impath)
% RENDER render a fractal and save it as image in a certain path
%    render(fract, impath) render the isosurface 'fract' and save it as image in path 'impath' 
clf('reset')
% Hide the figure as we only want to store it as image
figure('visible', 'off');

% Disable axes
ax = gca;
ax.Visible = 'off';

% Squared aspect ratio
pbaspect([1 1 1]);

% Empirical ('Good looking') values for view and cameraposition. 
view(-20,-50);
campos('manual');
campos([-2.5 -2.5 -2.5]);
camva(45);

% phong's enough
lighting phong
lightangle(-20, 0);

% patch the isosurface and create a mesh with fancy colors
iso = patch(fract,...
    'FaceColor',[0.11,.66,.78],...
    'EdgeColor','none');

% light and coloring parameters
iso.AmbientStrength = 0.3;
iso.DiffuseStrength = 0.6;
iso.SpecularColorReflectance = 1;
iso.SpecularExponent = 50;
iso.SpecularStrength = 1;

% save as image
F = getframe(gcf);
resimage = F.cdata;
imwrite(resimage, impath);
end