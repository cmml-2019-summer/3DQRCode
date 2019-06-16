%module to arbitrarily rotate sphere data 
%Rationale: the built-in "rotate()" function rotate graphical objects
%this script aims to rotate shapes given face,vertices data
%receives the X,Y,Z coordinates of all the origins (centrepoint) of each cube

%   by Nishant Suresh Aswani @niniack
%   Acknowledgement: Michael Linares @michaellinares

%   Materials used: 
%   http://www.ceet.niu.edu/faculty/kim/mee430/transformation.htm

%   Copyright, Composite Materials and Mechanics Laboratory NYU Tandon 2019


function [rotVertices] = threedRotate_(rawVertices,origin)
%receive [x y z] data and convert it to [x y z 1] for modifications
[rawVertices] = [rawVertices,ones(size(rawVertices,1),1)];
[rotVertices] = [zeros(size(rawVertices,1),size(rawVertices,2))];

%formulate first transformation matrix t1
t1 = eye(4,4);
t1(4,:) = [-origin , 1];

%generate random rotation angle
ang = deg2rad((360-1).*rand(3,1) + 1);
angX = ang(1,1);
angY = ang(2,1);
angZ = ang(3,1);

%formulate rotation matrix along x axis
r1 = [1 0 0 0; 0 cos(angX) sin(angX) 0; 0 -sin(angX) cos(angX) 0; 0 0 0 1];

%formulate rotation matrix along y axis
r2 = [cos(angY) 0 -sin(angY) 0; 0 1 0 0; sin(angY) 0 cos(angY) 0; 0 0 0 1];

%formulate rotation matrix along z axis
r3 = [cos(angZ) sin(angZ) 0 0; -sin(angZ) cos(angZ) 0 0; 0 0 1 0; 0 0 0 1];

%formulate second transformation matrix t2
t2 = eye(4,4);
t2(4,:) = [origin , 1];

for i = 1:size(rawVertices,1)
    rotVertices(i,:) = rawVertices(i,:)*t1*r1*r2*r3*t2;
end

rotVertices(:,4) = [];

end







% rotMat = [1,0,0;0,cos(i*rand(1)),sin(i*rand(1));0,-sin(i*rand(1)),cos(i*rand(1))];
