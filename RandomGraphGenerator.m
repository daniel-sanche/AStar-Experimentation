function [ G ] = RandomGraphGenerator( n, density )
   
    smallestDegree = 0;
    while(smallestDegree==0)
        A = sprand( n, n, density ); % generate adjacency matrix at random
        % normalize weights to sum to num of edges
        A = tril( A, -1 );    
        A = spfun( @(x) x./nnz(A), A );    
        % make it symmetric (for undirected graph)
        A = A + A.';

        G = graph(A);

        degArr = degree(G);
        smallestDegree = min(degArr(:));
    end

end

