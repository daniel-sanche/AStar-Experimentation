function Main( M, N, K, P, S, D )
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
    if ischar(S)
        S = str2num(S);
    end
    if ischar(D)
        D = str2num(D);
    end

    if(M < K*2 + 1)
       error('not enough locations for that many packages (M < N*2 + 1)'); 
    end
    
    %set the random seed value if there is one
    if S ~= 0
        rng(S)
    end

    G = GridGraphGenerator(M);
    [ Vehicles, Packages, GaragePt  ] = InitPositions(G, N, K);
    DisplayMap(G, Vehicles, Packages, GaragePt);

    %initialize initial goals for each vehicle
    for i=1:length(Vehicles)
        Vehicles(i).goal = FindGoal( Vehicles(i), Packages, [Vehicles(:).goal], P, M );
    end

    [ turns ] = RunLoop( Vehicles, Packages, GaragePt, G, M, P, D  )

end
