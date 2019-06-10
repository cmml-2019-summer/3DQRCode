function [Zpos] = assignZpos_(ZPOSMTX,cellsize,Zrange,row,col)
%this function gaurentees that no two neeiboring cells have touching
%faces/edges/corners

Zpos = randsample(Zrange,1);
%4 points are checked in relation to the current cell
while any(ZPOSMTX(row,col-1) - cellsize - 2:ZPOSMTX(row,col-1) + cellsize + 2 == Zpos) ... % checking the cell one col back
   || any(ZPOSMTX(row-1,col) - cellsize - 2:ZPOSMTX(row-1,col) + cellsize + 2 == Zpos) ... % checking the cell one row back
   || any(ZPOSMTX(row-1,col-1) - cellsize - 2:ZPOSMTX(row-1,col-1) + cellsize + 2 == Zpos) ... % checking the cell one row and col back
   || any(ZPOSMTX(row-1,col+1) - cellsize - 2:ZPOSMTX(row-1,col+1) + cellsize + 2 == Zpos)     % checking the cell one row back and one col forward
    
    Zpos = randsample(Zrange,1); % values are selected until a valid one is selected
    
end
end