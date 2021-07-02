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


%% Load 3rd party toolboxes

grasp_start_opt_3rd_party('bgirault_molene_dataset');

%% Select the graph
load('grasp_molene_data.mat');
g = molene_graphs{2};

g.show_graph_options.layout_boundaries = 0.1;
g.show_graph_options.color_map = flipud(colormap('gray'));
g.show_graph_options.edge_thickness = 2;
g.show_graph_options.edge_colormap = flipud(colormap('gray'));
% g.show_graph_options.edge_colorbar = false;
% g.show_graph_options.edge_color_scale = [0 1];
% g.show_graph_options.show_colorbar = true;

%% Compute the temperature increments
X = g.data{1};
dX = X(:, 2:end) - X(:, 1:(end - 1));

%% Mean and covariance
mu = mean(dX')';
S = cov(dX');

%% Plot the covariance and mean

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g, 'node_values', mu, 'show_colorbar', 1);
hf = gcf;
hf.Children(1).FontSize = 20;
print -depsc use_case_learning_mean.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
imagesc(S);
axis equal
pbaspect([1 1 1]);
colormap(flipud(colormap('gray')));
colorbar;
hf = gcf;
hf.Children(1).FontSize = 20;
hf.Children(2).FontSize = 20;
print -depsc use_case_learning_cov.eps

%% Plot the precision matrix

clf;
grasp_set_figure_size(gcf, [500 500]);
imagesc(S ^ -1);
axis equal
pbaspect([1 1 1]);
colormap(flipud(colormap('gray')));
colorbar;
hf = gcf;
hf.Children(1).FontSize = 20;
hf.Children(2).FontSize = 20;
print -depsc use_case_learning_precision.eps

%% Learn the combinatorial Laplacian

grasp_start_opt_3rd_party('usc_graph_learning');
N = grasp_nb_nodes(g);
L = estimate_cgl(S, ones(N) - eye(N));

%% Plot the Laplacian matrix

clf;
grasp_set_figure_size(gcf, [500 500]);
imagesc(L);
axis equal
pbaspect([1 1 1]);
colormap(flipud(colormap('gray')));
colorbar;
hf = gcf;
hf.Children(1).FontSize = 20;
hf.Children(2).FontSize = 20;
print -depsc use_case_learning_cgl.eps

%% Plot the learnt graph

g.A = diag(diag(L)) - L;
g.A_layout = g.A;
g.A_layout(g.A < 0.1) = 0;

clf;
grasp_set_figure_size(gcf, [500 550]);
grasp_show_graph(gca, g, 'show_edges', true, 'edge_colorbar', true, 'edge_color_scale', [0 1]);
hf = gcf;
hf.Children(1).FontSize = 20;
hf.Children(2).FontSize = 20;
print -depsc use_case_learning_graph.eps
