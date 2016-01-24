function [ G ] = GridGraphGenerator( m, weightRange )

    n = ceil(sqrt(m));

    A = zeros(n*n,n*n);

    for i=1:n:n*n
        for j=i:i+n-2
            weight = randi(weightRange,1,1);
            A(j, j+1) = weight;
            A(j+1, j) = weight;
            if j+n < n*n
                weight = randi(weightRange,1,1);
                A(j, j+n) = weight;
                A(j+n, j) = weight;
            end
        end
        if i>1
            weight = randi(weightRange,1,1);
            A(i-1, i-1+n) = weight;
            A(i-1+n, i-1) = weight;
        end
    end

    G = graph(A);

    while numnodes(G) > m 
        G = rmnode(G, numnodes(G));   
    end
end