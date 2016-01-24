function [  ] = DisplayMap( G, Vehicles, Packages, Garage )

h = plot(G);

highlight(h,Packages(:,1),'NodeColor','r', 'Marker', 's', 'MarkerSize', 10)
highlight(h,Packages(:,2),'NodeColor','magenta', 'Marker', 'o', 'MarkerSize', 10)
highlight(h,Vehicles,'NodeColor','g', 'Marker', '>', 'MarkerSize', 20)
highlight(h,Garage,'NodeColor','b', 'Marker', 'o', 'MarkerSize', 15)

end

