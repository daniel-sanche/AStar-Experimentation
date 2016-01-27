M = 20;
N = 3;
K = 2;
P = 2;

javaaddpath('./javatuples-1.2.jar');

if(M < N*2 + 1)
   error('not enough locations for that many packages (M < N*2 + 1)'); 
end

G = GridGraphGenerator(M, [1 20], 0.05);
[ Vehicles, Packages, GaragePt  ] = InitPositions(G, N, K);

done = false;
turn = 0;
totalCost = 0;

AStar( Vehicles, Packages, GaragePt, G, M )

output = ['finished in ', num2str(turn),' turns with cost ', num2str(totalCost) ];
disp(output);

