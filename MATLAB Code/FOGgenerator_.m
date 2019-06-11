function [ARRAY]=FOGgenerator_(ARRAY,cellsize,placement)
[n0,m0,~]= size(ARRAY);


xfcent = placement(1);
yfcent = placement(2);
n1=placement(3);
m1=placement(4);

%First Add%
xfrightbuff = floor(n1-xfcent-(ceil((n0-1)/2)));
xfleftbuff = n1-n0-xfrightbuff;
[~,m,p]= size(ARRAY);
NZL=zeros(xfleftbuff,m,p);
NZR=zeros(xfrightbuff,m,p);
ARRAY=cat(1,NZL,ARRAY,NZR);

%Second Add%
yfrightbuff = floor(m1-yfcent-(ceil((m0-1)/2)));
yfleftbuff = m1-m0-yfrightbuff;
[n,~,p]= size(ARRAY);
MZL=zeros(n,yfleftbuff,p);
MZR=zeros(n,yfrightbuff,p);
ARRAY=cat(2,MZL,ARRAY,MZR);

%Third Add%
% zfrightbuff = floor(m1-zfcent-(ceil((p0-1)/2)));
% zfleftbuff = m1-p0-zfrightbuff;
% [n,m,~]= size(ARRAY);
% PZL=zeros(n,m,zfleftbuff);
% PZR=zeros(n,m,zfrightbuff);
% ARRAY=cat(3,PZL,ARRAY,PZR);

%SetUpZFPosArray%
[z1,z2,z3]=size(ARRAY);
ZFPOSARRAY=zeros(z1/cellsize,z2/cellsize,z3/cellsize);

%________________Generate fog______________%


density=0.5;
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
        exclusionzone=cellsize*ceil((yfcent-n0/2+cellsize*2:cellsize:yfcent+n0/2-cellsize)/cellsize);
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