M = 14;
N = 2;
K = 2;
P = 2

G = GridGraphGenerator(M);
[ Vehicles, Packages, Garage  ] = InitPositions(G, N, K);
DisplayMap(G, Vehicles, Packages, Garage);
Vehicles(1).goal = FindGoal( Vehicles(1), Packages, [Vehicles(:).goal], P, M );