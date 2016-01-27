function [ path, cost ] = AStar( Vehicles, Packages, Garage, G, M )
    GMat = adjacency(G);
    DisplayMap(G, Vehicles, Packages, Garage);
    [path, cost] = AStarHelper(Vehicles, Packages, Garage, G, M, java.util.PriorityQueue);
    path = path(3:length(path));
end

function [ path, cost ] = AStarHelper( Vehicles, Packages, Garage, G, M, Queue)
    if(reachedGoal(Vehicles, Packages, Garage))
            path = [Previous, Destination];
            cost = costToPoint;
    else 
        numVehicles = length(Vehicles);
        %add new options to the queue
        
        CombinedOptions = zeros(4 ^ numVehicles, numVehicles);
        for i=1:numVehicles
           thisVehicle = Vehicles(i); 
           successorsFull = zeros(4,1);
           successors = neighbors(G, thisVehicle.position);
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
        
        
        nextNodes = setdiff(neighbors(G, Position), Visited);
        if length(nextNodes) ~= 0
            destNode = repmat(Destination, length(nextNodes), 1);
            Distances = ManhattenDistance(destNode, nextNodes, M);

            thisNode = repmat(Position, length(nextNodes), 1);
            Edges = findedge(G,thisNode,nextNodes);
            Weight = G.Edges.Weight(Edges);

            TotalCost = Distances + Weight;
            for i=1:length(TotalCost)
               trip= org.javatuples.Quartet(TotalCost(i) + costToPoint,nextNodes(i),Position, Weight(i));
               Queue.add(trip);
            end
        end

        foundNext = false;
        while ~foundNext
            nextVisit = Queue.remove;
            nextNumber = nextVisit.getValue1;
            if ~any(Visited == nextNumber)
                foundNext = true;
            end
        end        
        Weight = nextVisit.getValue3;

        [path, cost] = AStarHelper( nextNumber, Destination, G, M, Queue, Visited, nextVisit.getValue2, costToPoint+Weight);
        if any(path == Position) 
           path = [Previous, path];
        end
    end
end

function [done] = reachedGoal(Vehicles, Packages, Garage)
    done = false;
end


