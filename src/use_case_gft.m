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


%% Set the graph
use_case_import_graph;
g.show_graph_options.color_map = 'gray';
g.show_graph_options.edge_thickness = 2;
g.show_graph_options.edge_colormap = flipud(colormap('gray'));
g.show_graph_options.edge_colorbar = false;
g.show_graph_options.edge_color_scale = [0 1];
g.show_graph_options.colorbar = true;

%% Compute the LRW-based GFT
g = grasp_eigendecomposition(g, 'inner_product', 'degree');

%% Show several GFT modes
clf;
grasp_set_figure_size(gcf, [1000 1000]);
grasp_show_fouriermodes(g,...
                        'modes', 1:9,...
                        'titles', 0,...
                        'titles_fontsize', 22,...
                        'titles_margin', 0.04,...
                        'cmap', flipud(colormap('gray')),...
                        'node_size', 150,...
                        'value_scale', max(max(abs(g.Finv(:, 1:9)))) * [-1 1]);

print -depsc use_case_gft_modes.eps

%% Show the complete GFT, stacked

clf;

grasp_show_transform(gcf, g);
hf = gcf;
hf.Children.FontSize = 22;

print -depsc use_case_gft_full.eps
