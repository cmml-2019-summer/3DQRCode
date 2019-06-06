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

[n0,m0,p0]= size(ARRAY);
[n,m,p]= size(ARRAY);
midpoint = ceil(n0/2);
factorr=4;
offset = sqrt(2)*n0/2;
n1=n0*factorr;
m1=m0*factorr;
p1=p0*factorr;
radius=n1/2;

acceptableNrange = ceil(offset):floor(n1-offset);

nplacement = randsample(acceptableNrange,1);

adjustment1 = sqrt((floor(n1-offset))^2-(nplacement-radius)^2);

acceptableMrange = (ceil(adjustment1-radius)):(floor(adjustment1));

mplacement = randsample(acceptableMrange,1);

adjustment2 = sqrt((floor(n1-offset))^2-(nplacement-radius)^2-(mplacement-radius)^2);

acceptablePrange = (ceil(adjustment2-radius)):(floor(adjustment2));

pplacement = randsample(acceptablePrange,1);




nrightzerobarrier = n1-nplacement-(ceil((n0-1)/2));

nleftzerobarrier = n1-n0-nrightzerobarrier;


NZL=zeros(nleftzerobarrier,m,p);
size(NZL);
NZR=zeros(nrightzerobarrier,m,p);
size(NZR);
ARRAY=cat(1,NZL,ARRAY,NZR);

[n,m,p]= size(ARRAY);



mrightzerobarrier = m1-mplacement-(ceil((m0-1)/2));

mleftzerobarrier = m1-m0-mrightzerobarrier;

MZL=zeros(n,mleftzerobarrier,p);
size(MZL);
MZR=zeros(n,mrightzerobarrier,p);
size(MZR);

ARRAY=cat(2,MZL,ARRAY,MZR);
[n,m,p]= size(ARRAY);

prightzerobarrier = p1-pplacement-(ceil((m0-1)/2));

pleftzerobarrier = p1-p0-prightzerobarrier;

PZL=zeros(n,m,pleftzerobarrier);
PZR=zeros(n,m,prightzerobarrier);

ARRAY=cat(3,PZL,ARRAY,PZR); % new ARRAY is genearoted
size(ARRAY)

%________________Generate fog

count=1;
density=0.5;
allCol=8:8:800;
col=2;
while col<length(allCol)-1

layerbound = [1 -2*n1/2 (allCol(col)-n1/2)^2];
bounds=roots(layerbound);

range = bounds(2):8:bounds(1);
range=8*ceil(range/8);
numberofextracubes = ceil(density*(bounds(1) - bounds(2))/8);%add standard dev and av

for i=1:numberofextracubes
    idx = ceil(length(range)*rand(1));
    generatorposvec(i) = range(idx);
     while sum(ismember(generatorposvec,generatorposvec(i)))>1
         idx = ceil(length(range)*rand(1));
         generatorposvec(i) = range(idx);
     end
end
sort(generatorposvec)



generatorposvec=0;
col=col+10;
end


end

