function [  ] = DisplayMap( G, Vehicles, Packages, Garage )
%displays the graph along with the positions of vehicles, packages,
%destinations, and the garage
h = plot(G, 'EdgeLabel',G.Edges.Weight, 'NodeLabel',{});

UndeliveredIdx = find([Packages.destination] ~= [Packages.position]);
UndeliveredPackages = Packages(UndeliveredIdx);

highlight(h,[UndeliveredPackages(:).position],'NodeColor','r', 'Marker', 's', 'MarkerSize', 10)
highlight(h,[UndeliveredPackages(:).destination],'NodeColor','magenta', 'Marker', 'o', 'MarkerSize', 10)
highlight(h,[Vehicles(:).position],'NodeColor','g', 'Marker', '>', 'MarkerSize', 20)
highlight(h,Garage,'NodeColor','b', 'Marker', 'o', 'MarkerSize', 15)

end

