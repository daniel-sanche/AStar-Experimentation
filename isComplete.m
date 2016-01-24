function [ isDone ] = isComplete( Vehicles, Packages, Garage )
    isDone = false;
    if (length(find([Packages.destination] ~= [Packages.position])) == 0)
        if(length(find([Vehicles.position] ~= Garage)) == 0)
            isDone = true;
        end
    end
end

