function Main(M, N, K, P)
    %convert inputs to number values
    if ischar(M)
        M = str2num(M);
    end
    if ischar(N)
        N = str2num(N);
    end
    if ischar(K)
        K = str2num(K);
    end
    if ischar(P)
        P = str2num(P);
    end

    if(M < N*2 + 1)
       error('not enough locations for that many packages (M < N*2 + 1)'); 
    end

    G = GridGraphGenerator(M, [1 20], 0);
    [ Vehicles, Packages, GaragePt  ] = InitPositions(G, N, K);

    [Path, Cost] = AStar( N, Packages, GaragePt, G, M, P )

    output = ['finished in ', num2str(Cost),' turns' ];
    disp(output);
end
