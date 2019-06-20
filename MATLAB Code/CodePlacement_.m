% Determines the X Y Placement of the QR code within the fog
% The QR filename is imported for sizing, IdxVec is imported for cellsize,
% Factor is imported for fog sizing
% Placement = [ XmidPointofQRCODEinFOG YmidPointofQRCODEinFOG FOGdiameter ]

%   by Michael Linares @michaellinares
%   Achnologments: Nishant Suresh Aswani @niniack
%   Copyright, Composite Materials and Mechanics Laboratory NYU Tandon 2019

function [placement]=CodePlacement_(filename,IdxVec,factor)

UNREDUCEDQR = imbinarize(imread(filename)); %turns b/w rgb image into binary % qr code must be fully black, grey tones can cause problems
QRMTX = UNREDUCEDQR(:,:,1);
[QRsize,~]= size(QRMTX); % Gets size of QR code 
cellsize=IdxVec(1);

FOGsize = QRsize*factor; % Size of the Cube that contains the FOG Sphere / FOGsize = FOG diameter
placement(3) = FOGsize; % stored for use in later funcions
radiusofFOG = FOGsize/2; % 

offset = sqrt(2)*QRsize/2;

XfCentRange = ceil(offset):floor(FOGsize-offset);

xfplace = randsample(XfCentRange,1);
xfplace = cellsize*ceil(xfplace/cellsize)-cellsize/2;
placement(1)=xfplace;
adjustment1 = sqrt((floor(FOGsize-offset))^2-(xfplace-radiusofFOG)^2);

YfCentRange = (ceil(adjustment1-radiusofFOG)):(floor(adjustment1));

yfplace = randsample(YfCentRange,1);
yfplace=cellsize*ceil(yfplace/cellsize)-cellsize/2;
placement(2)=yfplace;

end
