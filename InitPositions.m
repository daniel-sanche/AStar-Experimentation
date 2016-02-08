function [ Vehicles, Packages, Garage  ] = InitPositions( G, N, K )
    nodeCount = numnodes(G);
    startPoint = randi([1 nodeCount],1,1);
    Vehicles = repmat(startPoint, 1, N);
    %create vehicles

    ClaimedSpots = [startPoint];

    Packages = struct;
    for i=1:K
        rand1 = startPoint;
        rand2 = startPoint;
        while ismember(rand1, ClaimedSpots)
            rand1 = randi([1 nodeCount],1,1);
        end
        ClaimedSpots = [ClaimedSpots, rand1];
        while ismember(rand2, ClaimedSpots)
            rand2 = randi([1 nodeCount],1,1);
        end
        ClaimedSpots = [ClaimedSpots, rand2];
       Packages(i).position =  rand1;
       Packages(i).destination =  rand2;
    end

    Garage = startPoint;
end

