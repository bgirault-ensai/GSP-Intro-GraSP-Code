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


%% Filter design

M = 10; % Chebyshev polynomial approximation degree

lambda_max = 2; % Maximum eigenvalue
K = 20; % How much of the [0,lambda_max] is covered by wavelets
J = 4; % Number of wavelet scales

lambda_min = lambda_max / K; % [lambda_min, lambda_max] -> wavelets

% abspline design

% x1 = 1;
% x2 = 2;
% alpha = 2;
% beta = 2;
% scales = logspace(log10(x2 / lambda_min), log10(x1 / lambda_max), J);

% Mexican hat design

scales = logspace(log10(2 / lambda_min), log10(1 / lambda_max), J);

cut = 0.34;

%% Graph filters

% design = 'abspline';
% [g, h] = filter_design_abspline(alpha, beta, x1, x2, lambda_min);
design = 'mexican';
[g, h] = filter_design_mexican_hat(lambda_min);

scaling_function = grasp_filter_struct;
scaling_function.type = 'kernel';
scaling_function.data = h;

wavelets = repmat(grasp_filter_struct, J, 1);
for j = 1:J
    wavelets(j).type = 'kernel';
    wavelets(j).data = @(x) g(scales(j) * x);
end

%% Spectral Response Plot

grasp_open_figure_name(sprintf('Filters: %s', design));
clf;
% grasp_set_figure_size(gcf, [1500 500]);
grasp_set_figure_size(gcf, [900 300]);
x = 0:0.001:2;
plot(x, grasp_apply_filter(x, scaling_function), 'k', 'LineWidth', 2, 'DisplayName', 'Scaling function');
hold on
for j = 1:J
    plot(x, grasp_apply_filter(x, wavelets(j)), 'Color', (j + 2) / (J + 4) * [1 1 1], 'DisplayName', sprintf('Wavelet scale $t_{%d}=%.2f$', j, scales(j)));
end
set(gca, 'YGrid', 'on');
plot(xlim, [cut cut], 'k--', 'DisplayName', 'Band threshold');
hold off
ylim([-0.05 0.5]);
hf = gcf;
hf.Children.FontSize = 20;
lh = legend('Location', 'eastoutside');
lh.Interpreter = 'latex';
print -depsc use_case_sgwt_filters.eps

%% Graph Filter Chebyshev Approximation

filterbank = repmat(grasp_filter_struct, J + 1, 1);
filterbank(1) = grasp_filter_cheb(scaling_function.data, M, 'chebfun_splitting', 'on');
for j = 1:J
    filterbank(j + 1) = grasp_filter_cheb(wavelets(j).data, M, 'chebfun_splitting', 'on');
end

%% Chebyshev Spectral Response Plot

grasp_open_figure_name(sprintf('Cheb. approx.: %s (M=%d)', design, M));
clf;
% grasp_set_figure_size(gcf, [1500 500]);
grasp_set_figure_size(gcf, [900 300]);
x = 0:0.001:2;
plot(x, grasp_apply_filter(x, filterbank(1)), 'k', 'LineWidth', 2, 'DisplayName', 'Scaling function');
hold on
for j = 1:J
    plot(x, grasp_apply_filter(x, filterbank(j + 1)), 'Color', (j + 2) / (J + 4) * [1 1 1], 'DisplayName', sprintf('Wavelet scale $t_{%d}=%.2f$', j, scales(j)));
end
set(gca, 'YGrid', 'on');
% plot(xlim, [cut cut], 'k--', 'DisplayName', 'Band Threshold');
hold off
ylim([-0.05 0.5]);
hf = gcf;
hf.Children.FontSize = 20;
lh = legend('Location', 'eastoutside');
lh.Interpreter = 'latex';
print -depsc use_case_sgwt_filters_cheb.eps

%% Graph

g = grasp_importcsv('use_case_import_graph_nodes.csv', 'use_case_import_graph_edges.csv');
g.show_graph_options.layout_boundaries = 0.05;
g.show_graph_options.color_map = flipud(colormap('gray'));
g.show_graph_options.edge_thickness = 2;
g.show_graph_options.edge_colormap = flipud(colormap('gray'));
g.show_graph_options.edge_colorbar = false;
g.show_graph_options.edge_color_scale = [0 1];
g.show_graph_options.show_colorbar = true;

%% GFT

g = grasp_eigendecomposition(g, 'inner_product', 'degree');

%% Transform matrix

N = grasp_nb_nodes(g);
G = zeros((J + 1) * N, N);
for j = 1:(J + 1)
    G((j - 1) * N + (1:N), :) = grasp_apply_filter(g, filterbank(j))';
end

scales_freqs = zeros(J + 1, 1);
bands = zeros(J + 1, 2);
for j = 2:(J + 1)
    scales_freqs(j) = fminbnd(@(x) -wavelets(j - 1).data(x), 0, lambda_max);
    bands(j, 1) = fminbnd(@(x) abs(wavelets(j - 1).data(x) - cut), 0, scales_freqs(j));
    bands(j, 2) = fminbnd(@(x) abs(wavelets(j - 1).data(x) - cut), scales_freqs(j), lambda_max);
end
bands(1, 2) = fminbnd(@(x) abs(scaling_function.data(x) - cut), 0, scales_freqs(2));

[~, node_ordering] = sort(g.Finv(:, 2));
for j = 1:(J + 1)
    G((j - 1) * N + (1:N), :) = G((j - 1) * N + node_ordering, :);
end

bands_colors = zeros(J + 1, 4);
for j = 1:(J + 1)
    bands_colors(j, 4) = 0.15 + mod(j, 2) * 0.1;
end

grasp_open_figure_name(sprintf('SGWT: %s (M=%d)', design, M));
clf;
grasp_set_figure_size(gcf, [700 2000]);
grasp_show_transform(gcf, g,...
                     'embedding', g.Finv(:, 2),...
                     'transform_matrix', G,...
                     'graph_frequencies', kron(scales_freqs, ones(N, 1)),...
                     'right_scale_size', 0.2,...
                     'bands', bands,...
                     'bands_colors', bands_colors,...
                     'support_scatter_mode', 'var_width_gray');
hf = gcf;
hf.Children.FontSize = 20;
print -depsc use_case_sgwt_plot.eps

%% Transform matrix: same with the exact filters

N = grasp_nb_nodes(g);
G = zeros((J + 1) * N, N);
G((1:N), :) = grasp_apply_filter(g, scaling_function)';
for j = 2:(J + 1)
    G((j - 1) * N + (1:N), :) = grasp_apply_filter(g, wavelets(j - 1))';
end

scales_freqs = zeros(J + 1, 1);
bands = zeros(J + 1, 2);
for j = 2:(J + 1)
    scales_freqs(j) = fminbnd(@(x) -wavelets(j - 1).data(x), 0, lambda_max);
    bands(j, 1) = fminbnd(@(x) abs(wavelets(j - 1).data(x) - cut), 0, scales_freqs(j));
    bands(j, 2) = fminbnd(@(x) abs(wavelets(j - 1).data(x) - cut), scales_freqs(j), lambda_max);
end
bands(1, 2) = fminbnd(@(x) abs(scaling_function.data(x) - cut), 0, scales_freqs(2));

[~, node_ordering] = sort(g.Finv(:, 2));
for j = 1:(J + 1)
    G((j - 1) * N + (1:N), :) = G((j - 1) * N + node_ordering, :);
end

bands_colors = zeros(J + 1, 4);
for j = 1:(J + 1)
    bands_colors(j, 4) = 0.15 + mod(j, 2) * 0.1;
end

grasp_open_figure_name(sprintf('SGWT: %s', design, M));
clf;
grasp_set_figure_size(gcf, [700 2000]);
grasp_show_transform(gcf, g,...
                     'embedding', g.Finv(:, 2),...
                     'transform_matrix', G,...
                     'graph_frequencies', kron(scales_freqs, ones(N, 1)),...
                     'right_scale_size', 0.2,...
                     'bands', bands,...
                     'bands_colors', bands_colors,...
                     'support_scatter_mode', 'var_width_gray');
hf = gcf;
hf.Children.FontSize = 20;
print -depsc use_case_sgwt_plot_exact.eps

%% 

function [g, h, p] = filter_design_abspline(alpha, beta, x1, x2, lambda_min)
    % abspline design: smooth g and g'
    M = [    x1 ^ 3   x1 ^ 2           x1            1 ;...
             x2 ^ 3   x2 ^ 2           x2            1 ;...
         3 * x1 ^ 2   2 * x1            1            0 ;...
         3 * x2 ^ 2   2 * x2            1            0];
    v = [         1        1   alpha / x1   -beta / x2]';

    % polynomial part of the abspline
    p = (M \ v)';

    % mother wavelet
    g = @(x) (x < x1)  .* (x1 ^ (-alpha) * x .^ alpha)...
           + (x >= x1) .* (...
                (x > x2)  .* (x2 ^ beta * x .^ (-beta))...
              + (x <= x2) .* polyval(p, x));

    % scaling function
    r = roots(p(1:3) .* [3 2 1]);
    gamma = max(1, polyval(p, r(r >= 1 & r <= 2)));
    h = @(x) gamma * exp(- (x ./ (0.6 * lambda_min)) .^ 4);
end

function [g, h] = filter_design_mexican_hat(lambda_min)
    g = @(x) x .* exp(-x);
    h = @(x) 1.2 * exp(-1) * exp(-(x / (0.4 * lambda_min)) .^ 4);
end
