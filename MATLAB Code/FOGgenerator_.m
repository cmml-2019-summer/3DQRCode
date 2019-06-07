function [ARRAY]=FOGgenerator_(ARRAY)

[n0,m0,p0]= size(ARRAY);
[~,m,p]= size(ARRAY);
%midpoint = ceil(n0/2);
factorr=4;
offset = sqrt(2)*n0/2;
n1=n0*factorr;
m1=m0*factorr;
p1=p0*factorr;
radius=n1/2;

XfCentRange = ceil(offset):floor(n1-offset);

xfcent = randsample(XfCentRange,1);
xfcent=404%8*ceil(xfcent/8)-4

adjustment1 = sqrt((floor(n1-offset))^2-(xfcent-radius)^2);

YfCentRange = (ceil(adjustment1-radius)):(floor(adjustment1));

yfcent = randsample(YfCentRange,1);
yfcent=404%8*ceil(yfcent/8)-4;
adjustment2 = sqrt((floor(n1-offset))^2-(xfcent-radius)^2-(yfcent-radius)^2);

ZfCentRange = (ceil(adjustment2-radius)):(floor(adjustment2));

zfcent = randsample(ZfCentRange,1);
zfcent=404%8*ceil(zfcent/8)-4;

xfrightbuff = n1-xfcent-(ceil((n0-1)/2));

xfleftbuff = n1-n0-xfrightbuff;


NZL=zeros(xfleftbuff,m,p);
size(NZL);
NZR=zeros(xfrightbuff,m,p);
size(NZR);
ARRAY=cat(1,NZL,ARRAY,NZR);

[n,~,p]= size(ARRAY);



mrightzerobarrier = m1-yfcent-(ceil((m0-1)/2));

mleftzerobarrier = m1-m0-mrightzerobarrier;

MZL=zeros(n,mleftzerobarrier,p);
size(MZL);
MZR=zeros(n,mrightzerobarrier,p);
size(MZR);

ARRAY=cat(2,MZL,ARRAY,MZR);
[n,m,~]= size(ARRAY);

prightzerobarrier = p1-zfcent-(ceil((m0-1)/2));

pleftzerobarrier = p1-p0-prightzerobarrier;

PZL=zeros(n,m,pleftzerobarrier);
PZR=zeros(n,m,prightzerobarrier);

ARRAY=cat(3,PZL,ARRAY,PZR); % new ARRAY is genearoted
size(ARRAY)

%________________Generate fog


density=0.5;
allrow=8:8:800;
fogrow=2;
count=1;
while fogrow<length(allrow)-1
    rowvariable=false;
    if sum(ismember(allrow(fogrow),(8*ceil((xfcent-99:8:xfcent+88)/8))))
        rowvariable=true;
    end
    
    layerbound = [1 -n1 (allrow(fogrow)-n1/2)^2];
    bounds=roots(layerbound);
    
    range = min(bounds):8:max(bounds);
    range=8*ceil(range/8);
    numberofextracubes = abs(ceil(density*(max(bounds) - min(bounds)))/8); %add standard dev and av
    exclusionzone=[];
    if rowvariable
        exclusionzone=8*ceil((yfcent-87:8:yfcent+88)/8);
    end
    for i=1:numberofextracubes
        idx = ceil(length(range)*rand(1));
        generatorposvec(i) = range(idx);
        while sum(ismember(generatorposvec,generatorposvec(i)))>1
            idx = ceil(length(range)*rand(1));
            generatorposvec(i) = range(idx);
        end
    end
    
    
    generatorposvec = sort(generatorposvec);
    generatorposvec(1)=[];
    generatorposvec(end)=[];
    generatorposvec(ismember(generatorposvec,exclusionzone))=[];
    
    startcount=1;
    endcount=0;
    for j=1:numberofextracubes
        
        
        if fix(j/2)~=j/2
            selectedcell = generatorposvec(startcount);
            startcount = startcount+1;
        elseif fix(j/2)==j/2
            selectedcell = generatorposvec(end-endcount);
            endcount = endcount+1;
        end
        
        %if sum(ARRAY(allrow(fogrow)-1,selectedcell-1,:))>1
        %    variable=true;
        %end
        
        
        ZposRange = [1 -n1 ((selectedcell-n1/2)^2+(allrow(fogrow)-n1/2)^2)];
        ZposBounds = 8*ceil(roots(ZposRange)/8);
        
        
        ZposSlots = min(ZposBounds):8:max(ZposBounds);
        ZposSlots(1) = [];
        ZposSlots(end) = [];
        zPos = ZposSlots(randi(length(ZposSlots)));
        
        
        Zcoordinates = zPos:zPos+8 ; % these coordiantes include compatiable zPos and the cell length number of coordanites above it
        Rowcoordinates = allrow(fogrow):allrow(fogrow+1) ; % these coordinates include the row positon and the cell length number ...
        Colcoordinates = selectedcell:selectedcell+8 ;
        ARRAY(Rowcoordinates,Colcoordinates,Zcoordinates) = 1; % the cube of coordiantes are "placed" inside the ARRAY
        
    end
    startcount=1;
    endcount=0;
    generatorposvec=[];
    fogrow=fogrow+1;
end
end



