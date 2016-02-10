function [ Path, TotalCost, Turns ] = AStar( numVehicles, Packages, Garage, G, M, P, D )    
    %the max number of options for choices each vehicle can make
    %move in any of 4 directions, stay still, pick up a package, or drop
    %one of p packages
    maxChoices = 6+P;
    
    %add new options to the queue
    InitialVehicles = repmat(Garage, numVehicles, 1);
    PriorityQueue = [0, {InitialVehicles}, {repmat({[]}, 1, numVehicles)}, {[Packages.position]}, {0}, {zeros(1,numVehicles)}];
    DisplayMap( G, cell2mat(PriorityQueue(1,2)), PriorityQueue{1,4}, [Packages.destination], Garage );
    pause(0.01);
    done = false;
    Turns = 0;
    while ~done
        Turns = Turns+1;
        %take the first choice off the queue
        VehiclePositions = cell2mat(PriorityQueue(1,2));
        PackagesCarried = PriorityQueue{1,3};
        PackagePositions = PriorityQueue{1,4};
        TotalCost = PriorityQueue{1,5};
        Path = PriorityQueue{1,6};
        %update the map
        if D
            DisplayMap( G, VehiclePositions, PackagePositions, [Packages.destination], Garage )
           pause(0.001);
        end
        PriorityQueue(1,:) = [];
        
        
        % check to see if we've reached our goal
        done = ReachedGoal(VehiclePositions, PackagePositions, [Packages.destination], PackagesCarried, Garage);
        if ~done
        
            CombinedOptions = zeros(maxChoices ^ numVehicles, numVehicles);
            CombinedCarrying = cell(maxChoices ^ numVehicles, numVehicles);
            for i=1:numVehicles
               [newChoices, newCarryingList] = GenerateNewChoices(VehiclePositions(i), PackagesCarried{i}, PackagePositions, [Packages.destination], Garage, G, maxChoices, P);

               eachNumSize = maxChoices^(numVehicles-i);
               numBlocks = maxChoices ^ (i-1);

               startPos = 1;
               for k=1:numBlocks
                    for j=1:maxChoices
                        %fill the block's space with the numbers repeated as
                        %many times as will fit
                        CombinedOptions(startPos:startPos+eachNumSize-1,i) = newChoices(j);
                        CombinedCarrying(startPos:startPos+eachNumSize-1,i) = newCarryingList(j);
                        startPos = startPos+eachNumSize;
                    end
               end
            end
            %remove all rows with a 0
            RowsWithZeros = all(CombinedOptions,2);
            CombinedOptions = CombinedOptions(RowsWithZeros,:);
            CombinedCarrying = CombinedCarrying(RowsWithZeros,:);

            %update package positions
            NewPackagePositions = UpdatePackagePositions(CombinedOptions, CombinedCarrying, PackagePositions);

            Values = HeuristicValues(CombinedOptions, NewPackagePositions, CombinedCarrying, [Packages.destination], Garage, M);
            %add extra weight to the heuristic
            %removes admissability, but achieves a result much faster
            %Values = (Values * 1.01);
            Values = Values + TotalCost;
            
            %add to priority queue
            currentLength = size(PriorityQueue,1);
            newLength = currentLength + size(Values,1);
            PriorityQueue(currentLength+1:newLength,1) = num2cell(Values);
            PriorityQueue(currentLength+1:newLength,2) = num2cell(CombinedOptions, 2);
            PriorityQueue(currentLength+1:newLength,3) = num2cell(CombinedCarrying, 2);
            PriorityQueue(currentLength+1:newLength,4) = num2cell(NewPackagePositions, 2);
            PriorityQueue(currentLength+1:newLength,5) = {TotalCost+1};
            PriorityQueue(currentLength+1:newLength,6) = {[Path ; reshape(VehiclePositions, 1,numVehicles)]};
            %sort the new queue
            [~, Index_A] = sort(cell2mat(PriorityQueue(:,1)));
            PriorityQueue = PriorityQueue(Index_A,:);
        end 
    end

end
