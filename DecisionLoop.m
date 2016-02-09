function [ turn, totalCost ] = DecisionLoop( Vehicles, Packages, GaragePt, G, M, P, D)
    %runs  loop to move vehicles around the graph until the destination
    %state is reached
    
    done = false;
    turn = 0;
    totalCost = 0;
    while ~done
        turn = turn + 1;
        pause(0.001);
        for i=1:length(Vehicles)
            newGoal = false;
            if Vehicles(i).goal ~= 0
                %update position
                path = Vehicles(i).path;
                oldPos = Vehicles(i).position;
                Vehicles(i).position = path(1);
                Vehicles(i).path = path(2:length(path));

                edge = findedge(G,oldPos,Vehicles(i).position);
                weight = G.Edges.Weight(edge);
                Vehicles(i).cost = Vehicles(i).cost - weight;
                totalCost = totalCost + weight;

                %move carried packages
                for j=1:length(Vehicles(i).packages)
                    Packages(Vehicles(i).packages(j)).position = Vehicles(i).position; 
                end

                %if reached goal, Preform action
                if Vehicles(i).position == Vehicles(i).goal
                    %attempt to pick up package
                    idx = find([Packages.position] == Vehicles(i).position & [Packages.claimed] == 0);
                    if ~isempty(idx)
                        thisPackage = Packages(idx);
                        Packages(idx).claimed = true;
                        holdingCount = length(Vehicles(i).packages);
                        Vehicles(i).packages(holdingCount+1) = idx;
                    else
                        %attempt to drop off package
                        dropIdx = find([Packages.destination] == Vehicles(i).position);
                        Vehicles(i).packages = setdiff(Vehicles(i).packages, dropIdx);
                    end
                    newGoal = true;
                end
            else
                newGoal = true;
            end
            if newGoal
                %find new goal
                Vehicles(i).goal = FindGoal( Vehicles(i), Packages, [Vehicles(:).goal], P, M );
                %if there is nothing left to pick up, head back to the garage
                if Vehicles(i).goal == 0 && Vehicles(i).position ~= GaragePt
                    Vehicles(i).goal = GaragePt;
                end
                if( Vehicles(i).goal ~= 0)
                   [path, cost] = AStar(Vehicles(i).position, Vehicles(i).goal, G, M);
                    Vehicles(i).path = path;
                    Vehicles(i).cost = cost;
                 else 
                     Vehicles(i).path = 0;
                     Vehicles(i).cost = 0;
                 end
            end
        end
        if D
            DisplayMap(G, Vehicles, Packages, GaragePt);
        end
        done = isComplete(Vehicles, Packages, GaragePt);
    end

end

