function [ newPosition ] = FindNextMove( Position, Destination, G, M )

nextNodes = neighbors(G, Position);
destNode = repmat(Destination, length(nextNodes), 1);

Distances = ManhattenDistance(destNode, nextNodes, M);

thisNode = repmat(Position, length(nextNodes), 1);
Edges = findedge(G,thisNode,nextNodes);
Weight = G.Edges.Weight(Edges);

TotalCost = Distances + Weight

[~, idx] = min(TotalCost);

newPosition = nextNodes(idx);

end

