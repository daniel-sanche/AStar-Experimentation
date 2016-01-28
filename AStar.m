function [ Path, TotalCost ] = AStar( numVehicles, Packages, Garage, G, M, P )    
    %the max number of options for choices each vehicle can make
    %move in any of 4 directions, stay still, pick up a package, or drop
    %one of p packages
    maxChoices = 6+P;
    
    %add new options to the queue
    InitialVehicles = repmat(Garage, numVehicles, 1);
    PriorityQueue = [0, {InitialVehicles}, {repmat({[]}, 1, numVehicles)}, {[Packages.position]}, {0}, {zeros(1,numVehicles)}];
    done = false;
    while ~done
        %take the first choice off the queue
      %  HeuristicValue = PriorityQueue(1,1)
        VehiclePositions = cell2mat(PriorityQueue(1,2));
        PackagesCarried = PriorityQueue{1,3};
        PackagePositions = PriorityQueue{1,4};
        TotalCost = PriorityQueue{1,5};
        Path = PriorityQueue{1,6};
        DisplayMap( G, VehiclePositions, PackagePositions, [Packages.destination], Garage )
        pause(0.01);
        PriorityQueue(1,:) = [];
        
        
        % check to see if we've reached our goal
        done = reachedGoal(VehiclePositions, PackagePositions, [Packages.destination], PackagesCarried, Garage);
        if ~done
        
            CombinedOptions = zeros(maxChoices ^ numVehicles, numVehicles);
            CombinedCarrying = cell(maxChoices ^ numVehicles, numVehicles);
            for i=1:numVehicles

               [newChoices, newCarryingList] = generateNewChoices(VehiclePositions(i), PackagesCarried{i}, PackagePositions, Garage, G, maxChoices, P);

               eachNumSize = maxChoices^(numVehicles-i);
               numBlocks = maxChoices ^ (i-1);

               startPos = 1;
               for k=1:numBlocks
                    for j=1:maxChoices
                        %fill the block's space with the numbers repeated as
                        %many times as will fit
                        CombinedOptions(startPos:startPos+eachNumSize-1,i) = newChoices(j);
                        CombinedCarrying(startPos:startPos+eachNumSize-1,i) = newCarryingList(j);
                        startPos = startPos+eachNumSize;
                    end
               end
            end
            %remove all rows with a 0
            RowsWithZeros = all(CombinedOptions,2);
            CombinedOptions = CombinedOptions(RowsWithZeros,:);
            CombinedCarrying = CombinedCarrying(RowsWithZeros,:);

            %update package positions
            NewPackagePositions = UpdatePackagePositions(CombinedOptions, CombinedCarrying, PackagePositions);

            Values = HeuristicValues(CombinedOptions, NewPackagePositions, CombinedCarrying, [Packages.destination], Garage, M);
            %Values = Values + CostToHere + 1;

            %add to priority queue
            currentLength = size(PriorityQueue,1);
            newLength = currentLength + size(Values,1);
            PriorityQueue(currentLength+1:newLength,1) = num2cell(Values);
            PriorityQueue(currentLength+1:newLength,2) = num2cell(CombinedOptions, 2);
            PriorityQueue(currentLength+1:newLength,3) = num2cell(CombinedCarrying, 2);
            PriorityQueue(currentLength+1:newLength,4) = num2cell(NewPackagePositions, 2);
            PriorityQueue(currentLength+1:newLength,5) = {TotalCost+1};
            PriorityQueue(currentLength+1:newLength,6) = {[Path ; reshape(VehiclePositions, 1,numVehicles)]};
            %sort the new queue
            [~, Index_A] = sort(cell2mat(PriorityQueue(:,1)));
            PriorityQueue = PriorityQueue(Index_A,:);
        end 
    end

end

function [done] = reachedGoal(VehiclePositions, PackagesPos, PackageDest, PackagesCarried, Garage)
    done = false; 
    if max(abs(VehiclePositions - Garage)) == 0 
        if max(abs(PackagesPos - PackageDest)) == 0
            [~, numCarried] = cellfun(@size, PackagesCarried);
            numCarried = sum(numCarried,2);
            if numCarried == 0
                done = true; 
            end
        end
    end 
end

function [newChoices, newCarry] = generateNewChoices(CurrentPosition, PackagesCarried, PackagePositions, Garage, G, maxSize, P)
    newCarry = repmat({PackagesCarried}, maxSize, 1);
    newChoices = zeros(maxSize, 1);
    successors = neighbors(G, CurrentPosition);
    newChoices(1:numel(successors)) = successors;
    
    %we want to add the ability to sit still, but only if 
    %it's sitting in the garage
    if CurrentPosition == Garage
        newChoices(5) = CurrentPosition;
    end
    
    %add option to pick up package if you're on one

    PackagesAtPosition = find(PackagePositions==CurrentPosition);
    PackagesAtPosition = setdiff(PackagesAtPosition, PackagesCarried);
    if(~isempty(PackagesAtPosition) && numel(PackagesCarried) < P)
        newChoices(6) = CurrentPosition;
        newCarry{6} = [PackagesCarried, PackagesAtPosition];
    end
    
    %add option to drop package if you're carrying one
    for i=1:numel(PackagesCarried)
        newChoices(i+6) = CurrentPosition;
        newCarry{i+6}(i) = [];
    end    
end

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
    
    values = sum(minDists, 2) + sum(NeedPickup, 2) + sum(DistToDest, 2) + sum(DropCost,2) + max(MaxDist, [], 2);
end

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


