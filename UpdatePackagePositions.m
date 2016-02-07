%this function moves the packages that are being carried by vehicles
function [NewPositions] = UpdatePackagePositions(VehiclePos, Carrying, OldPos)
    numberOptions = size(VehiclePos, 1);
    NewPositions = repmat(OldPos, numberOptions, 1);
    
    [~, numCarried] = cellfun(@size, Carrying);
    numCarried = sum(numCarried(:));
    
    if numCarried > 0
        for i=1:numel(OldPos)
            [row,col] = find(cellfun(@(x)ismember(i,x),Carrying));
            for j=1:size(row,1)
               newPos = VehiclePos(row(j),col(j));
               NewPositions(row(j), i) = newPos;
            end
        end
    end
end

