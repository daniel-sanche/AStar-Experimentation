function [  ] = DisplayMap( G, Vehicles, Packages, Garage )

h = plot(G);

highlight(h,[Packages(:).startPt],'NodeColor','r', 'Marker', 's', 'MarkerSize', 10)
highlight(h,[Packages(:).endPt],'NodeColor','magenta', 'Marker', 'o', 'MarkerSize', 10)
highlight(h,[Vehicles(:).position],'NodeColor','g', 'Marker', '>', 'MarkerSize', 20)
highlight(h,Garage,'NodeColor','b', 'Marker', 'o', 'MarkerSize', 15)

end

