M = 40;
N = 2;
K = 5;
P = 2;

javaaddpath('./javatuples-1.2.jar');

if(M < N*2 + 1)
   error('not enough locations for that many packages (M < N*2 + 1)'); 
end

G = GridGraphGenerator(M, [1 4], 0.05);
[ Vehicles, Packages, GaragePt  ] = InitPositions(G, N, K);
DisplayMap(G, Vehicles, Packages, GaragePt);

%initialize initial goals for each vehicle
for i=1:length(Vehicles)
    Vehicles(i).goal = FindGoal( Vehicles(i), Packages, [Vehicles(:).goal], P, M );
end

done = false;
turn = 0;
while ~done
    turn = turn + 1;
    pause(0.1);
    for i=1:length(Vehicles)
        if Vehicles(i).goal ~= 0
            %update position
            Vehicles(i).position = FindNextMove(Vehicles(i).position,  Vehicles(i).goal, G, M);

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
                %find new goal
                Vehicles(i).goal = FindGoal( Vehicles(i), Packages, [Vehicles(:).goal], P, M );
                %if there is nothing left to pick up, head back to the garage
                if Vehicles(i).goal == 0 && Vehicles(i).position ~= GaragePt
                    Vehicles(i).goal = GaragePt;
                end
            end
        end
    end
    DisplayMap(G, Vehicles, Packages, GaragePt);
    done = isComplete(Vehicles, Packages, GaragePt);
end

output = ['finished in ', num2str(turn),' turns'];
disp(output);

