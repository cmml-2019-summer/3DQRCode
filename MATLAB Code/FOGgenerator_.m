function [ARRAY]=FOGgenerator_(ARRAY,cellsize,factor)

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
<<<<<<< Updated upstream
[n,m,p]= size(ARRAY);
midpoint = ceil(n0/2);
factorr=4;
=======
[~,m,p]= size(ARRAY);

>>>>>>> Stashed changes
offset = sqrt(2)*n0/2;
n1=n0*factor;
m1=m0*factor;
p1=p0*factor;
radius=n1/2;

acceptableNrange = ceil(offset):floor(n1-offset);

nplacement = randsample(acceptableNrange,1);

adjustment1 = sqrt((floor(n1-offset))^2-(nplacement-radius)^2);

<<<<<<< Updated upstream
acceptableMrange = (ceil(adjustment1-radius)):(floor(adjustment1));
=======
xfcent = randsample(XfCentRange,1);
xfcent=cellsize*ceil(xfcent/cellsize)-cellsize/2;
>>>>>>> Stashed changes

mplacement = randsample(acceptableMrange,1);

adjustment2 = sqrt((floor(n1-offset))^2-(nplacement-radius)^2-(mplacement-radius)^2);

<<<<<<< Updated upstream
acceptablePrange = (ceil(adjustment2-radius)):(floor(adjustment2));
=======
yfcent = randsample(YfCentRange,1);
yfcent=cellsize*ceil(yfcent/cellsize)-cellsize/2;
adjustment2 = sqrt((floor(n1-offset))^2-(xfcent-radius)^2-(yfcent-radius)^2);
>>>>>>> Stashed changes

pplacement = randsample(acceptablePrange,1);

<<<<<<< Updated upstream


=======
zfcent = randsample(ZfCentRange,1);
zfcent=cellsize*ceil(zfcent/cellsize)-cellsize/2;

xfrightbuff = floor(n1-xfcent-(ceil((n0-1)/2)))

xfleftbuff = n1-n0-xfrightbuff
>>>>>>> Stashed changes

nrightzerobarrier = n1-nplacement-(ceil((n0-1)/2));

nleftzerobarrier = n1-n0-nrightzerobarrier;


NZL=zeros(nleftzerobarrier,m,p);
size(NZL);
NZR=zeros(nrightzerobarrier,m,p);
size(NZR);
ARRAY=cat(1,NZL,ARRAY,NZR);

[n,m,p]= size(ARRAY);



<<<<<<< Updated upstream
mrightzerobarrier = m1-mplacement-(ceil((m0-1)/2));
=======
mrightzerobarrier = floor(m1-yfcent-(ceil((m0-1)/2)));
>>>>>>> Stashed changes

mleftzerobarrier = m1-m0-mrightzerobarrier;

MZL=zeros(n,mleftzerobarrier,p);
size(MZL);
MZR=zeros(n,mrightzerobarrier,p);
size(MZR);

ARRAY=cat(2,MZL,ARRAY,MZR);
<<<<<<< Updated upstream
[n,m,p]= size(ARRAY);

prightzerobarrier = p1-pplacement-(ceil((m0-1)/2));
=======
>>>>>>> Stashed changes


[z1,z2,z3]=size(ARRAY);
ZFPOSARRAY=zeros(z1/cellsize,z2/cellsize,z3/cellsize);

%________________Generate fog

<<<<<<< Updated upstream
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

=======

density=0.75;
allrow=cellsize:cellsize:n1;
fogrow=2;

while fogrow<length(allrow)-1
    rowvariable=false;
    if sum(ismember(allrow(fogrow),(cellsize*ceil((xfcent-(n0/2-2*cellsize):cellsize:xfcent+(n0/2-cellsize))/cellsize))))
        rowvariable=true;
    end
    
    layerbound = [1 -n1 (allrow(fogrow)-n1/2)^2];
    bounds=roots(layerbound);
    
    range = min(bounds):cellsize:max(bounds);
    range=cellsize*ceil(range/cellsize);
    numberofextracubes = abs(ceil(density*(max(bounds) - min(bounds)))/cellsize); %add standard dev and av
    exclusionzone=[];
    if rowvariable
        exclusionzone=cellsize*ceil((yfcent-n0/2-2*cellsize:cellsize:yfcent+n0/2-cellsize)/cellsize);
    end
    for i=1:numberofextracubes
        idx = ceil(length(range)*rand(1));
        generatorposvec(i) = range(idx);
    end
    
    
    generatorposvec = sort(generatorposvec);
    generatorposvec(generatorposvec==generatorposvec(1))=[];
    generatorposvec(generatorposvec==generatorposvec(end))=[];
    generatorposvec(ismember(generatorposvec,exclusionzone))=[];
    numberofextracubes=length(generatorposvec);
    
    
    for j=1:numberofextracubes
        
        selectedcell=generatorposvec(j);

        ZposRange = [1 -n1 ((selectedcell-n1/2)^2+(allrow(fogrow)-n1/2)^2)];
        ZposBounds = cellsize*ceil(roots(ZposRange)/cellsize);
        
        
        ZposSlots = min(ZposBounds):cellsize:max(ZposBounds);
        ZposSlots(1) = [];
        ZposSlots(end) = [];
        zPos = assignZpos_(ZFPOSARRAY,cellsize,ZposSlots,fogrow,(selectedcell/cellsize));
        ZFPOSARRAY(fogrow,selectedcell/cellsize) = zPos;
        
        
        Zcoordinates = zPos:zPos+cellsize ; % these coordiantes include compatiable zPos and the cell length number of coordanites above it
        Rowcoordinates = allrow(fogrow):allrow(fogrow+1) ; % these coordinates include the row positon and the cell length number ...
        Colcoordinates = selectedcell:selectedcell+cellsize ;
        ARRAY(Rowcoordinates,Colcoordinates,Zcoordinates) = 1; % the cube of coordiantes are "placed" inside the ARRAY
        
    end
    
    generatorposvec=[];
    fogrow=fogrow+1;
end
end
>>>>>>> Stashed changes
