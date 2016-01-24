M = 14;
N = 2;
K = 2;
P = 2

G = GridGraphGenerator(M);
[ Vehicles, Packages, GaragePt  ] = InitPositions(G, N, K);
DisplayMap(G, Vehicles, Packages, GaragePt);
for i=1:length(Vehicles)
    Vehicles(i).goal = FindGoal( Vehicles(i), Packages, [Vehicles(:).goal], P, M );
    %if there is nothing left to pick up, head back to the garage
    if Vehicles(i).goal == 0 && Vehicles(i).position != GaragePt
        Vehicles(i).goal = GaragePt
    end
end