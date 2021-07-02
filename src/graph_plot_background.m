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


%% Load the Molène temperature graph
grasp_start_opt_3rd_party('bgirault_molene_dataset');
load('grasp_molene_data.mat');
g = molene_graphs{2};
g.A = grasp_adjacency_gaussian(g, 50000);
g.A = grasp_adjacency_thresh(g, 0.2);
g.node_names = cellfun(@(s) strjoin(strsplit(s, '_'), '\\_'), g.node_names, 'UniformOutput', 0);

%% Set the figure size
grasp_set_figure_size(gcf, [1400 1000]);

%% Set the default plotting options
g.show_graph_options.color_map = flipud(colormap('gray'));
g.show_graph_options.node_values = ones(grasp_nb_nodes(g), 1);
g.show_graph_options.node_display_size = 400;
g.show_graph_options.show_edges = false;

%% Plot with a background
grasp_show_graph(gca, g);
print('graph_plot_background.eps', '-depsc');

%% Subplot with a background
grasp_show_graph(gca, g, 'layout_boundaries', [-0.35 -0.21 ; 5.95 6.15] * 10 ^ 6);
print('graph_subplot_background.eps', '-depsc');

%% Graph with node labels
grasp_show_graph(gca, g,...
                 'node_text', 0,...
                 'node_text_fontsize', 12,...
                 'node_text_shift', [5000 5000],...
                 'node_text_background_color', [1 1 1 0.7],...
                 'node_text_background_edge', [0 0 0],...
                 'layout_boundaries', [-0.55 -0.17 ; 5.93 6.27] * 10 ^ 6);
print('graph_node_labels.eps', '-depsc');

% EPS output does not handle transparency, while pdf output has large
% margins... using pdfcrop to have both.
grasp_clean_pdf_export(gcf, 'graph_node_labels.pdf');
system('pdfcrop graph_node_labels.pdf');

%% Graph with node highlighting
clf
grasp_show_graph(gca, g,...
                 'highlight_nodes', [1 2 3],...
                 'highlight_nodes_size', 3000,...
                 'highlight_nodes_width', 3,...
                 'highlight_nodes_color', 0.4 * [1 1 1],...
                 'layout_boundaries', [-0.55 -0.17 ; 5.93 6.27] * 10 ^ 6);
print('graph_node_highlight.eps', '-depsc');

%% Graph with customized edges
clf
grasp_show_graph(gca, g,...
                 'show_edges', true,...
                 'edge_colormap', g.show_graph_options.color_map,...
                 'edge_colorbar', true,...
                 'edge_color_scale', [0 1],...
                 'edge_thickness', 2);
hf = gcf;
hf.Children(3).FontSize = 34;
print('graph_edge_tweaks.eps', '-depsc');

%% Directed graph
clf
g2 = grasp_directed_cycle(8);
g2.show_graph_options.color_map = flipud(colormap('gray'));
g2.show_graph_options.node_values = ones(grasp_nb_nodes(g2), 1);
g2.show_graph_options.node_display_size = 400;
grasp_show_graph(gca, g2,...
                 'arrow_max_tip_back_fraction', .15,...
                 'arrow_max_head_fraction', .5,...
                 'arrow_width_screen_fraction', .03);
% print('graph_directed_edges.eps', '-depsc');

%% Signal

x = g.data{1}(:, 1); % First temperatures reading in the dataset
grasp_show_graph(gca, g,...
                 'node_values', x,...
                 'color_map', flipud(colormap('gray')),...
                 'value_scale', [278 285],...
                 'show_colorbar', true,...
                 'node_display_size', 400,...
                 'node_marker_edge_width', 3);
hf = gcf;
hf.Children(1).FontSize = 24;
print('graph_signal.eps', '-depsc');
