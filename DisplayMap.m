function [  ] = DisplayMap( G, Vehicles, Packages, Garage )

%h = plot(G, 'EdgeLabel',G.Edges.Weight, 'NodeLabel',{});
h = plot(G);

UndeliveredIdx = find([Packages.destination] ~= [Packages.position]);
UndeliveredPackages = Packages(UndeliveredIdx);

highlight(h,[UndeliveredPackages(:).position],'NodeColor','r', 'Marker', 's', 'MarkerSize', 10)
highlight(h,[UndeliveredPackages(:).destination],'NodeColor','magenta', 'Marker', 'o', 'MarkerSize', 10)
highlight(h, Vehicles,'NodeColor','g', 'Marker', '>', 'MarkerSize', 20)
highlight(h,Garage,'NodeColor','b', 'Marker', 'o', 'MarkerSize', 15)

end

