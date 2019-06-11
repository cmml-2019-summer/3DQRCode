%module to convert all cubes to spheres for further obfuscation
%receives the X,Y,Z coordinates of all the origins (centrepoint) of each cube
function [faces, vertices] = cube_to_sphere(allDetectedOrigins)

%split the coordinate data into three distinct columns
x = allDetectedOrigins(:,1); %store all x values in a col
y = allDetectedOrigins(:,2); %store all y values in a col
z = allDetectedOrigins(:,3); %store all z values in a col

%determine the param for the spheres desired
rad = 4; %radius of spheres in spherical QRcode
res = 12; %number of faces of spheres in spherical QRcode

%count the number of spheres needed to be generated/the number of cubes
s = size(allDetectedOrigins); %the number of spheres
s = s(:,1);

%generate a standard sphere model
[sx,sy,sz] = sphere(res);

%move each sphere to an origin &
%convert all surface data points to face/vertex data points 
for i = 1:s
    fv(i) = surf2patch(rad*sx + x(i),rad*sy + y(i),rad*sz + z(i), 'triangles');
end

%remove unwanted vars
trash = {'sx','sy','sz','allDetectedOrigins','rad','res','x','y','z','i'};
clear(trash{:})
clear trash

%determine the number of vertices 
v = size(fv(1).vertices);
v = v(:,1);

%initialize an array to store face/vertex data
faces =[];
vertices = [];

%iteratre through and generate a face/vertex set 

%the faces have a constant added to them so as to prevent the formation of
%one structure
for i = 1:s
    vertices = vertcat(vertices, fv(i).vertices);
    faces = vertcat(faces, fv(i).faces + v*(i-1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LEGACY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%attempt at extracting xyz data from patch for stl

% for i = 1:m
%   finx = [finx get(fv2(i),'XData')];
%   finy = [finy get(fv2(i),'YData')];
%   finz = [finz get(fv2(i),'ZData')];
% end

%attempt at manipulating face data from patch data
% vertices = [get(fv2(1),'Vertices'); get(fv2(2),'Vertices')]
% faces = [get(fv2(1),'Faces'); get(fv2(2),'Faces')+16]
% 
% patch('Faces', faces, 'Vertices', vertices)
