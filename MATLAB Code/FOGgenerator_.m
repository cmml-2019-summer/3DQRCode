function [ARRAY]=FOGgenerator_(ARRAY,cellsize,factor)


[n0,m0,p0]= size(ARRAY);


[~,m,p]= size(ARRAY);

offset = sqrt(2)*n0/2;
n1=n0*factor;
m1=m0*factor;
p1=p0*factor;
radius=n1/2;

XfCentRange = ceil(offset):floor(n1-offset);
xfcent = randsample(XfCentRange,1);
xfcent = cellsize*ceil(xfcent/cellsize)-cellsize/2;
adjustment1 = sqrt((floor(n1-offset))^2-(xfcent-radius)^2);

YfCentRange = (ceil(adjustment1-radius)):(floor(adjustment1));
yfcent = randsample(YfCentRange,1);
yfcent = cellsize*ceil(yfcent/cellsize)-cellsize/2;
adjustment2 = sqrt((floor(n1-offset))^2-(xfcent-radius)^2-(yfcent-radius)^2);

ZfCentRange = (ceil(adjustment2-radius)):(floor(adjustment2));
zfcent = randsample(ZfCentRange,1);
zfcent = cellsize*ceil(zfcent/cellsize)-cellsize/2;


xfrightbuff = floor(n1-xfcent-(ceil((n0-1)/2)));
xfleftbuff = n1-n0-xfrightbuff;


NZL=zeros(xfleftbuff,m,p);
NZR=zeros(xfrightbuff,m,p);
ARRAY=cat(1,NZL,ARRAY,NZR);

[n,m,p]= size(ARRAY);


yfrightbuff = floor(m1-yfcent-(ceil((m0-1)/2)));
yfleftbuff = m1-m0-yfrightbuff;

MZL=zeros(n,yfleftbuff,p);
MZR=zeros(n,yfrightbuff,p);

ARRAY=cat(2,MZL,ARRAY,MZR);

[z1,z2,z3]=size(ARRAY);
ZFPOSARRAY=zeros(z1/cellsize,z2/cellsize,z3/cellsize);

%________________Generate fog


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

