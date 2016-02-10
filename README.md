# Problem Variant

The first solution I implemented was a simple hill climbing search. This algorithm is designed to run efficiently in a very simplified state space. For this solution, I made the following assumptions about the world:
1)	The graph forms a perfect grid. If the grid is not a square, the last row will be incomplete. The grid is made to resemble city intersections, and we can use Manhattan Distance as a heuristic
2)	There are no edge weights assigned to edges, so the hill climbing algorithm will never get stuck
3)	There are no holes or missing vertices in the graph, to make navigation simpler 
4)	Each package’s start position, destination, and the garage location is unique. This seems realistic in many real-world transportation applications, and it makes the computation a lot simpler.
5)	Packages are picked up and dropped off as soon as the vehicle arrives at the appropriate spot


# Algorithm
 The algorithm runs in four parts: 
1)	Each vehicle will choose a destination. The destination will either be the location of an unclaimed package, or the destination of a package the vehicle is carrying. The destination is chosen greedily, based on whatever destination is closest according to the heuristic value. When a vehicle chooses a destination, it will claim the location so no other vehicle will choose the same one. 
2)	Each turn, each vehicle will choose the best edge to move it closer to its destination. This is called a Hill Climbing Search, because it chooses the local best decision to move towards its goal. Moves are evaluated using the Manhattan Distance heuristic, meaning the number of edges to traverse between the vehicle and its destination.
3)	After the destination is reached, the vehicle will pick up or drop off a package, and choose the next closest destination.
4)	When there are no more available destinations left unclaimed, the vehicle will choose the garage as its next destination, and move in that direction.


# Conclusion

As long as the graph is connected and unweighted the algorithm is complete. This is because the Manhattan Distance heuristic will always be a perfect evaluation for the distance between the vehicle and its destination in such a simple environment. The Manhattan Distance is very simple to compute, so this algorithm can run very efficiently. The vehicle’s decisions can be made completely online and independent of each other, other than basic coordination to prevent choosing the same destination. For this reason, I was able to run this algorithm for very large values of M, N, K, and P. The main downside of this approach is that the the solution is not optimal. The destinations are chosen in a greedy manner, meaning that vehicles may not make the optimal decisions for which package to pick up in which order. Overall, this method is very useful if you have a large number of packages, the grid is a simple layout, and optimality is not a priority. With a little bit of planning ahead, however, we can get better results that work on more diverse graphs



