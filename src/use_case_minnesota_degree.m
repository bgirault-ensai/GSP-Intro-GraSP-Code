% Companion code for the GraSP appendix of the book Introduction to Graph Signal Processing
% Copyright (C) 2021 Benjamin Girault
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; version 2.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


g = grasp_minnesota('type', 'road');
clf;
grasp_set_figure_size(gcf, [1000 1000]);
grasp_show_graph(gca, g,... 
                 'node_values', diag(grasp_degrees(g)),...
                 'color_map', flipud(colormap('gray')),...
                 'show_colorbar', 1,...
                 'value_scale', [1 5],...
                 'node_display_size', 50);
cbh = colorbar;
cbh.FontSize = 18;
cbh.Ticks = 1:5;
print -depsc use_case_minnesota_degree.eps
