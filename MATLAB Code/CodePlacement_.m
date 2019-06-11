function [placement]=CodePlacement_(filename,IdxVec,factor)

UNREDUCEDQR = imbinarize(imread(filename));%turns b/w rgb image into binary % qr code must be fully black, grey tones can cause problems

QRMTX = UNREDUCEDQR(:,:,1);

[n0,m0]= size(QRMTX);
cellsize=IdxVec(1);
offset = sqrt(2)*n0/2;
n1=n0*factor;
placement(3)=n1;
m1=m0*factor;
placement(4)=m1;
radius=n1/2;

XfCentRange = ceil(offset):floor(n1-offset);

xfplace = randsample(XfCentRange,1);
xfplace=cellsize*ceil(xfplace/cellsize)-cellsize/2;
placement(1)=xfplace;
adjustment1 = sqrt((floor(n1-offset))^2-(xfplace-radius)^2);

YfCentRange = (ceil(adjustment1-radius)):(floor(adjustment1));

yfplace = randsample(YfCentRange,1);
yfplace=cellsize*ceil(yfplace/cellsize)-cellsize/2;
placement(2)=yfplace;

end
