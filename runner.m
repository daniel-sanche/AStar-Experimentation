M = 20;
N = 2;
K = 2;
P = 1;

javaaddpath('./javatuples-1.2.jar');

if(M < N*2 + 1)
   error('not enough locations for that many packages (M < N*2 + 1)'); 
end

G = GridGraphGenerator(M, [1 20], 0.05);
[ Vehicles, Packages, GaragePt  ] = InitPositions(G, N, K);

done = false;
turn = 0;
totalCost = 0;

[Path, Cost] = AStar( N, Packages, GaragePt, G, M, P )

output = ['finished in ', num2str(Cost),' turns' ];
disp(output);

