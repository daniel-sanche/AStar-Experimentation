function [newChoices, newCarry] = GenerateNewChoices(CurrentPosition, PackagesCarried, PackagePositions, PackageDestinations, Garage, G, maxSize, P)
    %this function returns a list of new ptions from the current state
    newCarry = repmat({PackagesCarried}, maxSize, 1);
    newChoices = zeros(maxSize, 1);
    successors = neighbors(G, CurrentPosition);
    newChoices(1:numel(successors)) = successors;
    
    %we want to add the ability to sit still, but only if 
    %it's sitting in the garage
    if CurrentPosition == Garage
        newChoices(5) = CurrentPosition;
    end
    
    %add option to pick up package if you're on one

    PackagesAtPosition = find(PackagePositions==CurrentPosition);
    PackagesAtPosition = setdiff(PackagesAtPosition, PackagesCarried);
    if(~isempty(PackagesAtPosition) && numel(PackagesCarried) < P)
        newChoices(6) = CurrentPosition;
        newCarry{6} = [PackagesCarried, PackagesAtPosition];
    end
    
    %add option to drop package if you're carrying one and you're on it's
    %destination
    for i=1:numel(PackagesCarried)
        if PackageDestinations(PackagesCarried(i)) == CurrentPosition
          newChoices(i+6) = CurrentPosition;
          newCarry{i+6}(i) = [];
        end
    end    
end
