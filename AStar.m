function [ path, cost ] = AStar( Position, Destination, G, M )
    [path, cost] = AStarHelper(Position, Destination, G, M, java.util.PriorityQueue, [], 0, 0);
    path = path(3:length(path));
    plot(G, 'EdgeLabel',G.Edges.Weight);
end

function [ path, cost ] = AStarHelper( Position, Destination, G, M, Queue, Visited, Previous, costToPoint )
    Visited = [Visited, Position];
    if(Position == Destination)
            path = [Previous, Destination];
            cost = costToPoint;
    else 
        nextNodes = setdiff(neighbors(G, Position), Visited);
        destNode = repmat(Destination, length(nextNodes), 1);
        Distances = ManhattenDistance(destNode, nextNodes, M);

        thisNode = repmat(Position, length(nextNodes), 1);
        Edges = findedge(G,thisNode,nextNodes);
        Weight = G.Edges.Weight(Edges);

        TotalCost = Distances + Weight;
        for i=1:length(TotalCost)
           trip= org.javatuples.Triplet(TotalCost(i) + costToPoint,nextNodes(i),Position);
           Queue.add(trip);
        end

        foundNext = false;
        while ~foundNext
            nextVisit = Queue.remove;
            nextNumber = nextVisit.getValue1;
            if ~any(Visited == nextNumber)
                foundNext = true;
            end
        end
        Edge = findedge(G,nextVisit.getValue2,nextNumber);
        Weight = G.Edges.Weight(Edge);
        
        [path, cost] = AStarHelper( nextNumber, Destination, G, M, Queue, Visited, nextVisit.getValue2, costToPoint+Weight);
        if any(path == Position) 
           path = [Previous, path];
        end
    end
end

