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


%% Generate and save a graph
% g = grasp_plane_rnd(50, 'display_threshold', 0.05);
% save('example_graph.mat', 'g');

%% Load the previously generated graph
load('example_graph.mat');

%% Setup the Matlab figure object to fixed and reproducible dimensions

%% Plot the graph, and save the image
clf
grasp_set_figure_size(gcf, [1000 1000]);
bw_cm = flipud(colormap('gray'));
grasp_show_graph(gca, g, 'node_values', ones(grasp_nb_nodes(g), 1), 'color_map', bw_cm, 'node_display_size', 400);
hf = gcf;
hf.Color = ones(3, 1);
print('example_graph.eps', '-depsc');

%% Compute the graph Fourier transform
g = grasp_eigendecomposition(g);

%% Show the first 12 GFT modes
clf
grasp_set_figure_size(gcf, round([1200 1000] / 2));
grasp_show_fouriermodes(g, 'modes', 1:12, 'node_size', 100, 'titles', 0, 'cmap', bw_cm, 'value_scale', 0.3 * [-1 1]);
hf = gcf;
hf.Color = ones(3, 1);
print('example_graph_gft_modes.eps', '-depsc');

%% Show the gft visualization with 1D embedding
clf
grasp_set_figure_size(gcf, [500 390]);
grasp_show_transform(gca, g);
hf = gcf;
hf.Color = ones(3, 1);
print('example_graph_gft_1Dembed.eps', '-depsc');

%% Graph Filter

h.type = 'kernel';
h.data = @(l) exp(-3 * l);
clf
grasp_set_figure_size(gcf, [300 200]);
[freq_resp_handle, legend_handle, freq_resp_interp_handle] = grasp_show_spectral_response(gca, g, h);
freq_resp_handle.MarkerEdgeColor = 'black';
freq_resp_interp_handle.Color = 'black';
hf = gcf;
hf.Color = ones(3, 1);
print('example_graph_spectral_response.eps', '-depsc');
