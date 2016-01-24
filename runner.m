M = 40;
N = 1;
K = 2;

G = GridGraphGenerator(M);
[ Vehicles, Packages, Garage  ] = InitPositions(G, N, K);
DisplayMap(G, Vehicles, Packages, Garage);