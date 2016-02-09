function Main( M, N, K, P, R, minW, maxW, S, D )
    %import the java tuples library
    javaaddpath('./javatuples-1.2.jar');
    
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
    if ischar(R)
        R = str2num(R);
    end
    if ischar(S)
        S = str2num(S);
    end
    if ischar(maxW)
        maxW = str2num(maxW);
    end
    if ischar(minW)
        minW = str2num(minW);
    end
    if ischar(D)
        D = str2num(D);
    end
    
    %set the random seed value if there is one
    if S ~= 0
        rng(S)
    end

    if(M < N*2 + 1)
       error('not enough locations for that many packages (M < N*2 + 1)'); 
    end

    G = GridGraphGenerator(M, [minW maxW], R);
    [ Vehicles, Packages, GaragePt  ] = InitPositions(G, N, K);
    
    [ turns, cost ] = DecisionLoop( Vehicles, Packages, GaragePt, G, M, P, D )
end
