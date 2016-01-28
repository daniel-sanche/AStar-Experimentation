function [  ] = DisplayMap( G, Vehicles, PackagesPos, PackageDest, Garage )

%h = plot(G, 'EdgeLabel',G.Edges.Weight, 'NodeLabel',{});
h = plot(G);

highlight(h,PackageDest,'NodeColor','magenta', 'Marker', 'o', 'MarkerSize', 10)
highlight(h,PackagesPos,'NodeColor','r', 'Marker', 's', 'MarkerSize', 10)
highlight(h, Vehicles,'NodeColor','g', 'Marker', '>', 'MarkerSize', 20)
highlight(h,Garage,'NodeColor','b', 'Marker', 'o', 'MarkerSize', 15)

end

