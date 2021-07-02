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
g.show_graph_options.color_map = flipud(colormap('gray'));
g.show_graph_options.edge_thickness = 2;
g.show_graph_options.edge_colormap = flipud(colormap('gray'));
g.show_graph_options.edge_colorbar = false;
g.show_graph_options.edge_color_scale = [0 1];
g.show_graph_options.show_colorbar = true;

%% Compute the LRW-based GFT
g = grasp_eigendecomposition(g, 'inner_product', 'degree');

%% A signal
x = grasp_delta(g, 10);

%% Matrix filter
h_mat = grasp_filter_struct;
h_mat.type = 'matrix';
h_mat.data = (eye(grasp_nb_nodes(g)) + 10 * g.Z) ^ -1;

% Plot 
clf;
grasp_set_figure_size(gcf, [500 500]);
imshow(h_mat.data);
caxis([0 0.25])
colorbar
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_matrix_mat.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', grasp_apply_filter(g, h_mat, x),...
                 'value_scale', [0 0.2]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_matrix.eps

%% Polynomial filter (degree 1)
h_poly_1 = grasp_filter_struct;
h_poly_1.type = 'polynomial';
h_poly_1.data = [-1/2 1];

% Plot 
clf;
grasp_set_figure_size(gcf, [500 500]);
imshow(grasp_apply_filter(g, h_poly_1));
caxis([0 0.25])
colorbar
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_poly_1_mat.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', grasp_apply_filter(g, h_poly_1, x),...
                 'value_scale', [0 0.2]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_poly_1.eps

%% Polynomial filter (degree 2)
h_poly_2 = grasp_filter_struct;
h_poly_2.type = 'polynomial';
h_poly_2.data = [1/4 -1 1];

% Plot 
clf;
grasp_set_figure_size(gcf, [500 500]);
imshow(grasp_apply_filter(g, h_poly_2));
caxis([0 0.25])
colorbar
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_poly_2_mat.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', grasp_apply_filter(g, h_poly_2, x),...
                 'value_scale', [0 0.2]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_poly_2.eps

%% Kernel
h_kern = grasp_filter_struct;
h_kern.type = 'kernel';
h_kern.data = @(x) (1 + 10 * x) .^ -1;

% Plot 
clf;
grasp_set_figure_size(gcf, [500 400]);
plot(0:0.001:2, grasp_apply_filter(0:0.001:2, h_kern), 'k', 'LineWidth', 2);
hf = gcf;
hf.Children.FontSize = 16;
legend({'$\frac{1}{1+10\lambda}$'}, 'Interpreter', 'latex', 'FontSize', 26)
print -depsc use_case_filters_kernel_fun.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', grasp_apply_filter(g, h_kern, x),...
                 'value_scale', [0 0.2]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_kernel.eps

%% Convolution
h_conv = grasp_filter_struct;
h_conv.type = 'convolution';
h_conv.data = g.Finv * ((1 + 10 * g.eigvals) .^ -1);

% Plot 
clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', h_conv.data,...
                 'value_scale', [-0.3 0.5]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_conv_signal.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', grasp_apply_filter(g, h_conv, x),...
                 'value_scale', [0 0.2]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_convolution.eps

%% Polynomial
h_poly = grasp_filter_kernel_to_poly(h_kern,...
                                'algorithm', 'graph_fit_lsqr',...
                                'poly_degree', 5,...
                                'graph', g);

% Plot 
clf;
grasp_set_figure_size(gcf, [500 400]);
plot(0:0.001:2, h_kern.data(0:0.001:2), 'k');
hold on
plot(g.eigvals, grasp_apply_filter(g.eigvals, h_poly), ':kx', 'LineWidth', 2, 'MarkerSize', 10);
hold off
hf = gcf;
hf.Children.FontSize = 16;
legend({'$1/(1+10\lambda)$', '\texttt{h\_poly}$(\lambda)$'}, 'Interpreter', 'latex', 'FontSize', 20)
print -depsc use_case_filters_poly_approx.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', grasp_apply_filter(g, h_poly, x),...
                 'value_scale', [0 0.2]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_poly.eps

%% Chebyshev Polynomial
h_cheby3 = grasp_filter_cheb(h_kern.data, 3);
h_cheby5 = grasp_filter_cheb(h_kern.data, 5);

% Plot 
clf;
grasp_set_figure_size(gcf, [500 400]);
plot(0:0.001:2, h_kern.data(0:0.001:2), 'k');
hold on
plot(0:0.001:2, grasp_apply_filter(0:0.001:2, h_cheby3), '-.k', 'LineWidth', 2, 'MarkerSize', 10);
plot(0:0.001:2, grasp_apply_filter(0:0.001:2, h_cheby5), '--k', 'LineWidth', 2, 'MarkerSize', 10);
hold off
hf = gcf;
hf.Children.FontSize = 16;
legend({'$1/(1+10\lambda)$', '\texttt{h\_cheby3}$(\lambda)$', '\texttt{h\_cheby5}$(\lambda)$'}, 'Interpreter', 'latex', 'FontSize', 20)
print -depsc use_case_filters_cheby_approx.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', grasp_apply_filter(g, h_cheby3, x),...
                 'value_scale', [0 0.2]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_cheby3.eps

clf;
grasp_set_figure_size(gcf, [500 500]);
grasp_show_graph(gca, g,...
                 'node_values', grasp_apply_filter(g, h_cheby5, x),...
                 'value_scale', [0 0.2]);
hf = gcf;
hf.Children(2).FontSize = 16;
print -depsc use_case_filters_cheby5.eps
