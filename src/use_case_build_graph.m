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


%% Empty graph
g = grasp_struct;
%% Add nodes
g.A = zeros(10);
%% 2D node embedding
g.layout = [0 0; 2 0; 4 0; (0:4)' ones(5, 1); 1.7 2.5; 3.3 2.5];
%% Plot margins: 10%
g.show_graph_options.layout_boundaries = .1;
%% Show the empty graph with node indices
clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g, 'color_map', 'gray', 'node_text', 'ID', 'node_text_shift', [.2 .1]);
print -depsc use_case_build_graph_ids.eps
%% Edges
g.A(1, [4 9]) = 1;
g.A(2, 10) = 1;
g.A(3, 10) = 1;
g.A(4, 9) = 1;
g.A(5, [6 9]) = 1;
g.A(6, [5 7 9 10]) = 1;
g.A(7, 10) = 1;
g.A(8, 10) = 1;
g.A(9, 10) = 1;
g.A(10, 9) = 1;
%% Show the final graph
clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g, 'color_map', 'gray', 'arrow_max_head_fraction', 2, 'arrow_width_screen_fraction', 0.015, 'arrow_max_tip_back_fraction', 0.07);
print -depsc use_case_build_graph.eps
