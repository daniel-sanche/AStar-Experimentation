function [ Vehicles, Packages, Garage  ] = InitPositions( G, N, K )

    nodeCount = numnodes(G);

    startPoint = randi([1 nodeCount],1,1);
    Vehicles = repmat(startPoint,N,1);

    Packages = zeros(K, 2);
    
    for i=1:K
        rand1 = startPoint;
        rand2 = startPoint;
        while rand1 == startPoint
            rand1 = randi([1 nodeCount],1,1);
        end
        while rand2 == startPoint || rand2 == rand1
            rand2 = randi([1 nodeCount],1,1);
        end
       Packages(i,1) =  rand1;
       Packages(i,2) =  rand2;
    end

    Garage = startPoint;
end

