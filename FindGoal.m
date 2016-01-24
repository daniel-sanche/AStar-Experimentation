function [ Dest ] = FindGoal( Vehicle, Packages, Goals, P, M )

    holdingCount = length(Vehicle.packages);
    PossibleDestinations = [];

    %add goals of what we're holdig to the list of possible destinations 
    for i=1:holdingCount
       packageIdx = Vehicle.packages(i);
       package = Packages(packageIdx);
       endPt = package.destination;
       PossibleDestinations = [PossibleDestinations, endPt];
    end

    %if we have room to carry more, add the positions of 
    %remaining packages to the list
    if holdingCount < P
        UnclaimedIdx = find([Packages.claimed] == 0)
        PossibleDestinations = [PossibleDestinations, [Packages(UnclaimedIdx).position]];
    end

    %remove packages that are already the goal of another vehicle
    PossibleDestinations = setdiff(PossibleDestinations,Goals)

    if length(PossibleDestinations) == 0
       Dest = 0
    else
       PosMat =  repmat(Vehicle.position, 1, length(PossibleDestinations));
        Distances = ManhattenDistance(PossibleDestinations, PosMat, M);
        [~, idx] = min(Distances);

        Dest = PossibleDestinations(idx); 
    end
end

