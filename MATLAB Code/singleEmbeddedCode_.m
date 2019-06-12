
function [ARRAY,cellsize,allDetectedOrigins,placement] = singleEmbeddedCode_(filename,factor)

count=0;

[QRMTX,IdxVec,QSdim,rectangleADJ] = IdxSpacer_(filename);
[m,~] = size(QRMTX)

if factor
[placement] = CodePlacement_(filename,IdxVec,factor);
placement(5)=rectangleADJ
ARRAY = zeros(m,m,placement(3));
end

[m,~] = size(QRMTX);
ARRAY = zeros(m,m,m); % ARRAY's size is based on the pixel dimension of the qr image]
numberofcols = length(IdxVec); % refeeres to the number of columns and rows in qr code
cellsize = IdxVec(1);
ZPOSMTX = nan(numberofcols,numberofcols); % stores the z coordinate of the bottom of each cell cube in same row/col that the cell cube is stored

cumVec = cumsum(IdxVec);


Zrange = cumVec(QSdim+1:end-QSdim-1); % the positions in which cell cubes can be stored // QSdim is used here so that a square is produced // the -1 from the end accounts for posibility of a cell being placed on the final position


posVec = cumsum(IdxVec);% the pixel position of the near the top/left corner most point on each cell

col = 1; row = 1;
allDetectedOrigins = [];
validZPos = [];

while row <= numberofcols % going through all rows checking for cells
    
    while col <= numberofcols % going through all columns checking for cells
        
        if QRMTX(posVec(row),posVec(col)) % if this logical is true then a cell is detected at that row/col
            allDetectedOrigins = [allDetectedOrigins ; posVec(row)+posVec(1)/2 posVec(col)+posVec(1)/2];
            if row > 1 % the first row is always empty (Quiet Space)
                
                if factor
                ZposRange = [1 -placement(3) ((placement(1)+posVec(row)-m/2-placement(3)/2)^2+(placement(2)+posVec(col)-m/2-placement(3)/2)^2)];
                ZposBounds = cellsize*ceil(roots(ZposRange)/cellsize);%(ceil(adjustment2-radius)):cellsize:(floor(adjustment2));
                Zrange = min(ZposBounds):cellsize:max(ZposBounds);
                end
                
                
                zPos = assignZpos_(ZPOSMTX,cellsize,Zrange,row,col); % randomly selects z coordinate of the given cell // assignelev checks for corner/edge/face inteferance
                ZPOSMTX(row,col) = zPos; %zPos is saved inside ZPOSMTX
                
                if isfinite(zPos)
                    validZPos = [validZPos; zPos];
                end
            end
            %these next lines select the coordanites in ARRAY
            Zcoordinates = zPos:zPos + cellsize ; % these coordiantes include compatiable zPos and the cell length number of coordanites above it
            Rowcoordinates = posVec(row):posVec(row+1) ; % these coordinates include the row positon and the cell length number ...
            Colcoordinates = posVec(col):posVec(col+1) ;
            ARRAY(Rowcoordinates,Colcoordinates,Zcoordinates) = 1; % the cube of coordiantes are "placed" inside the ARRAY
            count=count+1;
        end
        
        col = col + 1; % next row
        
    end
    
    col = 1; % row is done
    row = row + 1;% next row
    
end
allDetectedOrigins = [allDetectedOrigins validZPos];

if factor
allDetectedOrigins(:,1) = allDetectedOrigins(:,1)+placement(1)-m/2;
allDetectedOrigins(:,2) = allDetectedOrigins(:,2)+placement(2)-m/2;
allDetectedOrigins(:,3) = allDetectedOrigins(:,3)-cellsize/2;
size(ARRAY,1)

else
    placement=0;
end

end

