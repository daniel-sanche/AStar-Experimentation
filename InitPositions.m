function [ Vehicles, Packages, Garage, newSeed  ] = InitPositions( G, N, K, Seed )
    if ~isempty(Seed) 
        %initialize positions using seed value
        Garage = Seed(1);
        Vehicles = repmat(Garage, 1, N);
        j = 1;
        Packages = struct;
        for i=2:2:length(Seed)
             Packages(j).position = Seed(i);
             Packages(j).destination = Seed(i+1);
        end
        newSeed = Seed;
    else 
        %initialize positions without a seed value
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
        newSeed = ClaimedSpots;
    end
end

