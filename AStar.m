function [ result ] = AStar( Position, Destination, G, M )
    result = AStarHelper(Position, Destination, G, M, java.util.PriorityQueue, [], 0, 0)
    h = plot(G, 'EdgeLabel',G.Edges.Weight);
end

function [ result ] = AStarHelper( Position, Destination, G, M, Queue, Visited, Previous, costToPoint )
    if(Position == Destination)
            result = costToPoint;
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

        nextVisit = Queue.remove;
        nextNumber = nextVisit.getValue1;
        Edge = findedge(G,nextVisit.getValue2,nextNumber);
        Weight = G.Edges.Weight(Edge);
        
        result = AStarHelper( nextNumber, Destination, G, M, Queue, [Visited, Position], nextVisit.getValue2, costToPoint+Weight);
    end
end

