# Problem Variant

For my final attempt, I decided to use A* Search for all possible positions of vehicles. Instead of each vehicle being it’s own decision-making entity, the entire network uses one “mind” to pre-plan the optimal route through the graph to deliver packages in an optimal fashion. The world’s definition is as follows:
1)	Again, the graph is in a simple grid formation
2)	To simplify A*, the graph is always unweighted in this implementation
3)	Edges can be disconnected from the graph, like in Greedy A*
4)	Each package’s start position, destination, and the garage location is unique
5)	It costs a turn to pick up or drop off a package



# Algorithm
1)	Generate a list of all possible successor states from the current state. These states are based on possible movements of the vehicles, and include actions such as picking up or dropping off packages.
2)	Calculate the heuristic value estimates for each successor state. These values represent an estimated cost of reaching the goal from the current state, using a complex formula described below.
3)	Add the cumulative cost to the heuristic value for each new state to create the total cost
4)	Select the next state with the lowest cost using a priority queue, and update the positions of vehicles and packages to match the new state
5)	Repeat until the destination state is reached, with all packages delivered and all vehicles back in the garage



# Conclusion

This algorithm is the first one to achieve both a complete, and an optimal solution. A* is guaranteed to achieve optimality as long as the heuristic used is admissible, and consistent. If a heuristic is admissible, that means that it always underestimates the cost to the goal, relative to the true cost. Consistency is similar to admissibility, but slightly stricter. A heuristic is consistent as long as successor states are always greater than or equal to the cost of their parents. For this problem, the heuristic I used had five parts:
1)	The minimum distance from any vehicle to any package. Using this value will cause vehicles to move towards packages to achieve a lower cost
2)	The number of undelivered packages that haven’t been picked up. This will reward states where the vehicle picks up the package, after arriving at it’s location
3)	The Manhattan Distance between a package and its destination. This will encourage vehicles to carry packages toward their goals.
4)	A cost for packages that haven’t been dropped at their location. This cost will encourage the vehicles to drop packages after they arrive at their destination
5)	The maximum distance between anything (vehicle, destination, or package) and the garage. This value was chosen to encourage vehicles to return to the garage after dropping off all packages. I decided to use the distance to any object, rather than just vehicles, because otherwise it would discourage vehicles from leaving the garage at all. In this way, vehicles will be free to move as far as the furthest destination without affecting the heuristic, but they will eventually return to the garage after dropping off all packages for a minimal score.

These heuristic portions were carefully chosen to ensure that the cost will always be an underestimate. Each cost is a move that the vehicle will have to make at some point to compete the route, so it satisfies the admissibility/consistency constraints, and results in an optimal solution.

Although the solution is optimal, the algorithm leaves a lot to be desired. It runs well with small values of N, M, K, and P; but it becomes intractable when those numbers start to rise. When N is increased, new vehicles are added to the simulation, causing the branching factor, or number of successor states, to rise exponentially. My program would run pretty smoothly with one or two vehicles, but rising the number to three would cause a lot of waiting. Increasing K will increase the number of packages on the map, which will cause the vehicles to try many more paths to try to find the most efficient routes between them. The heuristic values will be competing with each other a lot more, resulting in more state changes and longer computation time. I would often have trouble with K values greater than two or three. Increasing M will increase the size of the map, which often results in longer path distances and more states being tested. Increasing P will increase the vehicle carrying capacity, which can actually improve run time in some cases, because vehicles won’t have to plan as complicated routes. Finally, there is another parameter, R, that controls the rate of edges being removed from the graph, resulting in vertices that should be neighbors being disconnected. When there are more holes in the graph, the Manhattan Distance heuristic can’t plan ahead, leading to dead ends and extra exploring. Overall, any of these parameters being increased can lead to significantly longer computation time.
	I attempted to counteract this affect by modifying the successor function used to generate new states. Originally, I had new states for the four possible edges from each vehicle’s position, states for the vehicle to do nothing, and states to pick up or drop off any packages it may be carrying or on top of. A lot of these states proved to be unneeded in most contexts, and added a lot of bloat to the priority queue. To speed up computation, I decided to only packages to be dropped off when they are on their destination, instead of at any point. I also only allow a vehicle to remain stationary if it is on the garage space, otherwise it should always move somewhere. This limits the number of new states to be at most 5 when N=1.
	Another decision I made to speed up computation was to remove edge weights on the graph. A* is designed to handle edge weights really well, but they do cause a lot more exploring to be necessary, causing significantly longer run times. I decided that for this algorithm, I would focus on getting it to run on basic unweighted graphs in order to get better results.


