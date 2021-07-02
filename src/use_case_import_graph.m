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


%% Empty Graph
g = grasp_struct;
%% 2D Vertex Embedding
g.layout = dlmread('use_case_import_graph_nodes.csv', ',', [1 0 50 1]);
%% Incidence Matrix (list of edges)
I = dlmread('use_case_import_graph_edges.csv', ',', 1, 0);
%% Adjacency Matrix
g.A = sparse([I(:, 1) ; I(:, 2)], [I(:, 2) ; I(:, 1)], [I(:, 3) ; I(:, 3)]);
%% Automatic Plot Boundaries
g.show_graph_options.layout_boundaries = 0.05;
%% Plotting
clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'color_map', 'gray',...
                 'edge_thickness', 2,...
                 'edge_colormap', flipud(colormap('gray')),...
                 'edge_colorbar', true,...
                 'edge_color_scale', [0 1]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_import_graph.eps
