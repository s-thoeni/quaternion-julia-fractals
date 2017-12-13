function render(fract, impath)
clf('reset')
figure('visible', 'off');
ax = gca;
ax.Visible = 'off';
pbaspect([1 1 1]);

view(-20,-50);
campos('manual');
campos([-2.5 -2.5 -2.5]);
camva(45);

lighting phong
lightangle(-20, 0);

iso = patch(fract,...
'FaceColor',[0.11,.66,.78],...
'EdgeColor','none');

iso.AmbientStrength = 0.3;
iso.DiffuseStrength = 0.6;
iso.SpecularColorReflectance = 1;
iso.SpecularExponent = 50;
iso.SpecularStrength = 1;

F = getframe(gcf);
resimage = F.cdata;
imwrite(resimage, impath);
end