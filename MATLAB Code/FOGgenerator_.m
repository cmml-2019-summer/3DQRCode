function [ARRAY]=FOGgenerator_(ARRAY)

%  ARRAY(:,:,1) = [ 1 0 1;
%      0 1 0;
%      1 0 1];
% 
%  ARRAY(:,:,2) = [ 0 1 0;
%      1 0 1;
%      0 1 0];
%  ARRAY(:,:,3) = [ 1 0 1;
%      0 1 0;
%      1 0 1];
% 

[n,m,p]= size(ARRAY);
midpoint = ceil(n/2);
factorr=4;
offset = sqrt(2)*n/2;
n1=n*factorr;
m1=m*factorr;
p1=p*factorr;
radius=n1/2;

acceptableNrange = ceil(offset):floor(n1-offset);

nplacement = randsample(acceptableNrange,1);

adjustment1 = sqrt((floor(n1-offset))^2-(nplacement-radius)^2);

acceptableMrange = (ceil(adjustment1-radius)):(floor(adjustment1));

mplacement = randsample(acceptableMrange,1);

adjustment2 = sqrt((floor(n1-offset))^2-(nplacement-radius)^2-(mplacement-radius)^2);

acceptablePrange = (ceil(adjustment2-radius)):(floor(adjustment2));

pplacement = randsample(acceptablePrange,1);




nrightzerobarrier = n1-nplacement-(ceil((n-1)/2));

nleftzerobarrier = n1-n-nrightzerobarrier;


NZL=zeros(nleftzerobarrier,m,p);
NZR=zeros(nrightzerobarrier,m,p);
ARRAY=cat(1,NZL,ARRAY,NZR);

[n,m,p]= size(ARRAY);



mrightzerobarrier = m1-mplacement-(ceil((n-1)/2));

mleftzerobarrier = m1-m-mrightzerobarrier;

MZL=zeros(n,mleftzerobarrier,p);
MZR=zeros(n,mrightzerobarrier,p);

ARRAY=cat(2,MZL,ARRAY,MZR);
[n,m,p]= size(ARRAY);

prightzerobarrier = p1-pplacement-(ceil((n-1)/2));

pleftzerobarrier = p1-p-prightzerobarrier;

PZL=zeros(n,m,pleftzerobarrier);
PZR=zeros(n,m,prightzerobarrier);

ARRAY=cat(3,PZL,ARRAY,PZR);

end

