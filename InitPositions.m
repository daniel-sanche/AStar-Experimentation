function [ Vehicles, Packages, Garage  ] = InitPositions( G, N, K )
  %create the initial positions for packages and the garage

    nodeCount = numnodes(G);

    startPoint = randi([1 nodeCount],1,1);
    Vehicles = struct('position', repmat({startPoint}, N, 1), 'packages', repmat({[]}, N, 1), 'goal', repmat({0}, N, 1));
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
       Packages(i).claimed =  false;
    end

    Garage = startPoint;
end

