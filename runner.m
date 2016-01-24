M = 14;
N = 2;
K = 2;
P = 2;

if(M < N*2 + 1)
   error('not enough locations for that many packages (M < N*2 + 1)'); 
end

G = GridGraphGenerator(M);
[ Vehicles, Packages, GaragePt  ] = InitPositions(G, N, K);
DisplayMap(G, Vehicles, Packages, GaragePt);

%initialize initial goals for each vehicle
for i=1:length(Vehicles)
    Vehicles(i).goal = FindGoal( Vehicles(i), Packages, [Vehicles(:).goal], P, M );
end


for i=1:length(Vehicles)
    %update position
    Vehicles(i).position = Vehicles(i).goal;
    
    %move carried packages

    %if reached goal, Preform action
    if Vehicles(i).position == Vehicles(i).goal
        %attempt to pick up package
        idx = find([Packages.position] == Vehicles(i).position & [Packages.claimed] == 0);
        if length(idx) ~= 0
            thisPackage = Packages(idx);
            Packages(idx).claimed = true;
            holdingCount = length(Vehicles(i).packages);
            Vehicles(i).packages(holdingCount+1) = idx;
        else
            %%attempt to drop off package
            dropIdx = find([Packages.destination] == Vehicles(i).position);
            droppers = setdiff(dropIdx, Vehicles(i).packages);
            Vehicles(i).packages = setdiff(Vehicles(i).packages, droppers);
        end
        %find new goal
        Vehicles(i).goal = FindGoal( Vehicles(i), Packages, [Vehicles(:).goal], P, M );
        %if there is nothing left to pick up, head back to the garage
        if Vehicles(i).goal == 0 && Vehicles(i).position ~= GaragePt
            Vehicles(i).goal = GaragePt;
        end
    end
end
DisplayMap(G, Vehicles, Packages, GaragePt);

