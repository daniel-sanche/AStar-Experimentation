function [ Vehicles, Packages, Garage  ] = InitPositions( G, N, K )

    nodeCount = numnodes(G);

    startPoint = randi([1 nodeCount],1,1);
    Vehicles = struct('position', repmat({startPoint}, N, 1), 'packages', repmat({[]}, N, 1), 'goal', repmat({0}, N, 1));
    %create vehicles

    Packages = struct;
    for i=1:K
        rand1 = startPoint;
        rand2 = startPoint;
        while rand1 == startPoint
            rand1 = randi([1 nodeCount],1,1);
        end
        while rand2 == startPoint || rand2 == rand1
            rand2 = randi([1 nodeCount],1,1);
        end
       Packages(i).position =  rand1;
       Packages(i).destination =  rand2;
       Packages(i).claimed =  false;
    end

    Garage = startPoint;
end

