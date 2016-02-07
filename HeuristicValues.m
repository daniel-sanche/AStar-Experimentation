%this function assignes heuristic values to the new states
function [values] = HeuristicValues(newPositionsArray, packagePositions, PackagesCarried, PackageDests, Garage, M)
    %create a 3d array. Each 3rd D stack represents the distance to a
    %certain package. Each row represents a different decision option. Each column
    %represents a different robot. For each decision, we want to find the
    %sum of min distances from any robot to each package
    [rows, cols] = size(newPositionsArray);
    numPackages = size(packagePositions,2);
    reshapedPackages = reshape(packagePositions,[rows,1,numPackages]);
    reshapedPackages = repmat(reshapedPackages, 1,cols,1);
    
    vehiclePositions = repmat(newPositionsArray, 1,1,numPackages);
    
    distances = ManhattenDistance(vehiclePositions, reshapedPackages, M);
    
    %this tells us the minimum distance to each package for each
    %potential move
    minDists = min(distances, [], 2);
    minDists=reshape(minDists, size(minDists,1),numPackages);
    
    %add a cost for not being dropped off at the right location
    %(otherwise the vehicle will continue holding it)
    [~, numCarried] = cellfun(@size, PackagesCarried);
    numCarried = sum(numCarried,2);
    destinationsFormated = repmat(PackageDests, rows, 1);
    posDiff = abs(packagePositions - destinationsFormated);
    InPosition = (posDiff == 0);
    
    BeingCarried = zeros(rows, numPackages);
    if sum(numCarried(:)) ~= 0
        for i=1:numPackages
            [r,~] = find(cellfun(@(x)ismember(i,x),PackagesCarried));
            BeingCarried(r,i) = 1; 
        end
    end
    DropCost = ones(rows,numPackages);
    DropCost(InPosition + ~BeingCarried==2) = 0;
 
    %if a package is at its destination, it doesn't matter how close it
    %is to a vehicle
    minDists(InPosition==1) = 0;
    
    %we also want to add a cost for every package not being carried
    NeedPickup = ones(rows,numPackages);
    NeedPickup(BeingCarried==1) = 0;
    NeedPickup(InPosition==1) = 0;
    
    %we also want to add in the distance between the packages and their
    %destination
    DistToDest = ManhattenDistance(destinationsFormated, packagePositions, M);
    
    %track the distance from the garage to the vehicles
    GarageFormatted = repmat(Garage, size(newPositionsArray));
    CarsToGarage = ManhattenDistance(GarageFormatted, newPositionsArray, M);
    
    GarageFormatted = repmat(Garage, size(packagePositions));
    PackagesToGarage = ManhattenDistance(GarageFormatted, packagePositions, M);
    
    DestsToGarage = ManhattenDistance(GarageFormatted, destinationsFormated, M);
    %we don't want to consider the distances for packages or destinations
    %where the package was already dropped off
    PackagesToGarage(InPosition==1) = 0;
    DestsToGarage(InPosition==1) = 0;

    
    MaxDist = [max(DestsToGarage, [], 2), max(PackagesToGarage,[],2), CarsToGarage];
    
    FinalHeuristic = [min(minDists, [], 2), sum(NeedPickup, 2), sum(DistToDest, 2), sum(DropCost,2), max(MaxDist, [], 2)];
    values = sum(FinalHeuristic, 2);
end

