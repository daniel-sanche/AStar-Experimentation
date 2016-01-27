function [ path, cost ] = AStar( Vehicles, Packages, Garage, G, M )
    DisplayMap(G, Vehicles, Packages, Garage);
    
    numVehicles = length(Vehicles);
    %add new options to the queue

    PriorityQueue = [0, 0, Vehicles];
    while ~reachedGoal(Vehicles, Packages, Garage)
        %take the first choice off the queue
        ChosenPositions = PriorityQueue(1,3:numVehicles+2);
        CostToHere = PriorityQueue(1,2);
        PriorityQueue(1,:) = [];
        
        CombinedOptions = zeros(4 ^ numVehicles, numVehicles);
        for i=1:numVehicles
           successorsFull = zeros(4,1);
           successors = neighbors(G, ChosenPositions(i));
           successorsFull(1:length(successors),1) = successors;
           eachNumSize = 4^(numVehicles-i);
           numBlocks = 4 ^ (i-1);

           startPos = 1;
           for k=1:numBlocks
                for j=1:4
                    %fill the block's space with the numbers repeated as
                    %many times as will fit
                    CombinedOptions(startPos:startPos+eachNumSize-1,i) = successorsFull(j);
                    startPos = startPos+eachNumSize;
                end
           end
        end
        %remove all rows with a 0
        CombinedOptions = CombinedOptions(all(CombinedOptions,2),:);
        Values = HeuristicValues(CombinedOptions, Packages, Garage, M);
        Values = Values + CostToHere + 1;
        CostToPointVector = repmat(CostToHere + 1, length(Values), 1);

        %add to priority queue
        PriorityQueue(length(PriorityQueue)+1:length(PriorityQueue)+length(Values),:) = [Values, CostToPointVector, CombinedOptions];
        PriorityQueue = sortrows(PriorityQueue);
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


