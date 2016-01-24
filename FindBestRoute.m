function [ result ] = FindBestRoute( Position, Destination, G, M, Queue, Visited )
    if(Position ~= Destination)
        
        nextNodes = setdiff(neighbors(G, Position), Visited);
        destNode = repmat(Destination, length(nextNodes), 1);
        Distances = ManhattenDistance(destNode, nextNodes, M);

        thisNode = repmat(Position, length(nextNodes), 1);
        Edges = findedge(G,thisNode,nextNodes);
        Weight = G.Edges.Weight(Edges);

        TotalCost = Distances + Weight;
        for i=1:length(TotalCost)
           trip= org.javatuples.Triplet(TotalCost(i),nextNodes(i),Position);
           Queue.add(trip);
        end

        nextVisit = Queue.remove;
        nextNumber = nextVisit.getValue1;
        answer = FindBestRoute( nextNumber, Destination, G, M, Queue, [Visited, Position]);
        result = [Position, answer];
    else 
        result = Position;
    end
end

