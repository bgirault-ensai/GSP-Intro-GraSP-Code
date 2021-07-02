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


%% Load our toy graph
grasp_start_opt_3rd_party('usc_graphs');
load('toy_graph.mat')
toy_graph.distances = grasp_distances_layout(toy_graph);
toy_graph.A = grasp_adjacency_gaussian(toy_graph, 1.5) .* toy_graph.A;

%% Set default plotting options
toy_graph.show_graph_options.color_map = flipud(colormap('gray'));
toy_graph.show_graph_options.show_colorbar = true;
toy_graph.show_graph_options.layout_boundaries = 0.05;

%% Compute the combinatorial Laplacian-based GFT
toy_graph = grasp_eigendecomposition(toy_graph);

%% Start a fork of usc_ssl_sampling that also returns the sampling set order
grasp_start_opt_3rd_party('usc_ssl_sampling');

%% Compute the sampling set

N = grasp_nb_nodes(toy_graph);
power = 3;
L_k = toy_graph.M ^ power;
sampling_set = compute_opt_set_inc((L_k + L_k') / 2, power, N)';

%% Plot the sampling set order on the graph
[~, IX] = sort(sampling_set);

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, toy_graph, 'node_values', IX);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_sampling_order.eps

%% Assign each sampled node to a GFT mode (row)
mask = sparse((1:N)', sampling_set, ones(N, 1), N, N);

%% Plot the GFT matrix with the sampled nodes
clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_transform(gcf, toy_graph, 'highlight_entries', mask);
hf = gcf;
hf.Children.FontSize = 16;
yyaxis left
hf.Children.Children(1).CData = [0 0 0];
hf.Children.Children(1).LineWidth = 2;
hf.Children.Children(1).SizeData = 60;
print -depsc use_case_sampling_gft.eps

%% Same plots for the normalized Laplacian
toy_graphNL = grasp_eigendecomposition(toy_graph, 'matrix', 'norm_lapl');

L_k = toy_graphNL.M ^ power;
sampling_set = compute_opt_set_inc((L_k + L_k') / 2, power, N)';

[~, IX] = sort(sampling_set);

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, toy_graphNL, 'node_values', IX);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_sampling_order_normlapl.eps

mask = sparse((1:N)', sampling_set, ones(N, 1), N, N);

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_transform(gcf, toy_graphNL, 'highlight_entries', mask);
hf = gcf;
hf.Children.FontSize = 16;
yyaxis left
hf.Children.Children(1).CData = [0 0 0];
hf.Children.Children(1).LineWidth = 2;
hf.Children.Children(1).SizeData = 60;
print -depsc use_case_sampling_gft_normlapl.eps
