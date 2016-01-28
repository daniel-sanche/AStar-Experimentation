function [ path, cost ] = AStar( Vehicles, Packages, Garage, G, M, P )
    DisplayMap(G, Vehicles, Packages, Garage);
    
    numVehicles = length(Vehicles);
    %the max number of options for choices each vehicle can make
    %move in any of 4 directions, stay still, pick up a package, or drop
    %one of p packages
    maxChoices = 6+P;
    
    %add new options to the queue

    PriorityQueue = [0, {Vehicles}, {repmat({[]}, 1, numVehicles)}, {[Packages.position]}];
    while ~reachedGoal(Vehicles, Packages, Garage)
        %take the first choice off the queue
        VehiclePositions = cell2mat(PriorityQueue(1,2));
        PackagesCarried = PriorityQueue{1,3};
        PackagePositions = PriorityQueue{1,4};
        PriorityQueue(1,:) = [];
        
        CombinedOptions = zeros(maxChoices ^ numVehicles, numVehicles);
        CombinedCarrying = cell(maxChoices ^ numVehicles, numVehicles);
        for i=1:numVehicles
            
           [newChoices, newCarryingList] = generateNewChoices(VehiclePositions(i), PackagesCarried{i}, PackagePositions, G, maxChoices, P);
          
           eachNumSize = maxChoices^(numVehicles-i);
           numBlocks = maxChoices ^ (i-1);

           startPos = 1;
           for k=1:numBlocks
                for j=1:maxChoices
                    %fill the block's space with the numbers repeated as
                    %many times as will fit
                    CombinedOptions(startPos:startPos+eachNumSize-1,i) = newChoices(j);
                    CombinedCarrying(startPos:startPos+eachNumSize-1,i) = newCarryingList(i);
                    startPos = startPos+eachNumSize;
                end
           end
        end
        %remove all rows with a 0
        RowsWithZeros = all(CombinedOptions,2);
        CombinedOptions = CombinedOptions(RowsWithZeros,:);
        CombinedCarrying = CombinedCarrying(RowsWithZeros,:);
        Values = HeuristicValues(CombinedOptions, Packages, Garage, M);
        %Values = Values + CostToHere + 1;

        %add to priority queue
        currentLength = size(PriorityQueue,1);
        newLength = currentLength + size(Values,1);
        PriorityQueue(currentLength+1:newLength,1) = num2cell(Values);
        PriorityQueue(currentLength+1:newLength,2) = num2cell(CombinedOptions, 2);
        PriorityQueue(currentLength+1:newLength,3) = num2cell(CombinedCarrying, 2);
        %sort the new queue
        [~, Index_A] = sort(cell2mat(PriorityQueue(:,1)));
        PriorityQueue = PriorityQueue(Index_A,:);
        
    end

end

function [done] = reachedGoal(Vehicles, Packages, Garage)
    done = false;
    if max(Vehicles - Garage) == 0 
        if max([Packages.position] - [Packages.destination]) == 0
            done = true; 
        end
    end
end

function [newChoices, newCarry] = generateNewChoices(CurrentPosition, PackagesCarried, PackagePositions, G, maxSize, P)
    newCarry = repmat({PackagesCarried}, maxSize, 1);
    newChoices = zeros(maxSize, 1);
    successors = neighbors(G, CurrentPosition);
    newChoices(1:numel(successors)) = successors;
    newChoices(5) = CurrentPosition;
    
    %add option to pick up package if you're on one
    idxOfPackageAtCurrentPos = find(PackagePositions==CurrentPosition);
    if(~isempty(idxOfPackageAtCurrentPos) && isempty(find(PackagesCarried==idxOfPackageAtCurrentPos)) && numel(PackagesCarried < P))
        newChoices(6) = CurrentPosition;
        newCarry{6} = [PackagesCarried, idxOfPackageAtCurrentPos];
    end
    
    %add option to drop package if you're carrying one
    for i=1:numel(PackagesCarried)
        newChoices(i+6) = CurrentPosition;
        newCarry{i+6}(i) = [];
    end    
end

function [values] = HeuristicValues(newPositionsArray, Pacakges, Garage, M)
    %create a 3d array. Each 3rd D stack represents the distance to a
    %certain package. Each row represents a different decision option. Each column
    %represents a different robot. For each decision, we want to find the
    %sum of min distances from any robot to each package
    [rows, cols] = size(newPositionsArray);
    packagePositions = reshape([Pacakges.position],[1,1,length([Pacakges.position])]);
    packagePositions = repmat(packagePositions, rows,cols,1);
    vehiclePositions = repmat(newPositionsArray, 1,1,length(Pacakges));
    
    distances = ManhattenDistance(vehiclePositions, packagePositions, M);
    
    %this tells us the minimum distance to each package (3rd d) for each
    %potential move (1st D)
    minDists = min(distances, [], 2);
    %we add the two together to result in the total
    sumDist = sum(minDists, 3);
    values = sumDist;
end


