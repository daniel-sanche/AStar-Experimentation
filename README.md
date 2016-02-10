# Problem Variant

For the second implementation I attempted, I used an A* approach to plan the course between the vehicle and its destination, but the vehicles still chose their next destination using a greedy method. The world can be described as follows:
1)	The graph, again, is in a grid formation, compatible with Manhattan Distance
2)	This time, the edges can be assigned weights. Weight ranges can be specified as a parameter to the program.
3)	Edges can be randomly removed in the graph, disconnecting some vertices from their neighbors. The graph will still be a single connected component, however. The percent chance of the edges being removed is specified as a parameter to the program. (Note that edges will never be removed if they are required to keep a vertex connected to the graph)
4)	Like before, each package’s start position, destination, and the garage location is unique
5)	Packages are picked up and dropped off as soon as the vehicle arrives at the appropriate spot

# Algorithm
1)	Like with the Hill Climbing Search, each vehicle will choose its destination in a greedy manner using the Manhattan Distance heuristic.
2)	After a destination is found, the optimal path to its location is computed using A* search. This will result in a stack of vertices to visit in order to reach the destination.
3)	At each turn, the vehicle will move to the next location in its pre-computed path, and it off the stack.
4)	Once a vehicle reaches its destination, it will pick up or drop off its package, and choose a new destination
5)	When there are no more available destinations left unclaimed, the vehicle will choose the garage as its next destination.

# Conclusion

This second implementation is only a slight improvement on the Hill Climbing Search. The main improvement is the ability to find paths even if the graph is weighted or has missing edges. In this way, it is more generally applicable than the Hill Climbing Approach. Unfortunately, these improvements come at a cost; this method runs much slower than the previous algorithm, because the A* used to find paths is much more intensive than the simple Manhattan Distance used previously. Furthermore, the solution still isn’t optimal, because destinations are assigned in a greedy manner. While the algorithm is still complete, and paths from vehicles to packages are optimal, that means little when the overall solution isn’t. This solution extends the previous one to work in more robust conditions, but overall it has little added benefit, and slower computation time.


