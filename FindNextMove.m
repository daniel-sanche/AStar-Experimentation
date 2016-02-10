function [ newPosition ] = FindNextMove( Position, Destination, G, M )
%based on the vehicle's current position and it's destination, the mehod
%finds the next edge to travel to best reach the goal

    %create arrays of neighbour nodes, and the destination
    nextNodes = neighbors(G, Position);
    destNode = repmat(Destination, length(nextNodes), 1);

    %find the manhatten distance from each neighbour node to the
    %destination
    Distances = ManhattenDistance(destNode, nextNodes, M);

    %find the index of the choice with the lowest cost
    [~, idx] = min(Distances);

    %chose that vertex as the next choice
    newPosition = nextNodes(idx);

end

