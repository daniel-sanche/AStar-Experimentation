function [ G ] = GridGraphGenerator( m )

    n = ceil(sqrt(m));

    A = zeros(n*n,n*n);

    for i=1:n:n*n
        for j=i:i+n-2
            A(j, j+1) = 1;
            A(j+1, j) = 1;
            if j+n < n*n
                A(j, j+n) = 1;
                A(j+n, j) = 1;
            end
        end
        if i>1
        A(i-1, i-1+n) = 1;
        A(i-1+n, i-1) = 1;
        end
    end

    G = graph(A);

    while numnodes(G) > m 
        G = rmnode(G, numnodes(G));   
    end
end