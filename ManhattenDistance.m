function [ Dist ] = ManhattenDistance( pt1, pt2, M )

n = ceil(sqrt(M));
row1 = floor((pt1-1) / n)
row2 = floor((pt2-1) / n)

col1 = mod((pt1-1), n)
col2 = mod((pt2-1), n)

Dist = abs(row1 - row2) + abs(col1 - col2)

end

