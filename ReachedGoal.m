function [done] = ReachedGoal(VehiclePositions, PackagesPos, PackageDest, PackagesCarried, Garage)
    %this function is called to check if the goal has been completed
    %returns a bool indicating whether we are done
    done = false; 
    if max(abs(VehiclePositions - Garage)) == 0 
        if max(abs(PackagesPos - PackageDest)) == 0
            [~, numCarried] = cellfun(@size, PackagesCarried);
            numCarried = sum(numCarried,2);
            if numCarried == 0
                done = true; 
            end
        end
    end 
end