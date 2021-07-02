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


N = 30;

% Erdos-Renyi: Uniform Random Graph Model (*@\index{Graphs!Erd\H{o}s-R\'{e}nyi}@*)
p = 0.1; % Edge probability
er  = grasp_erdos_renyi(N, p, 'directed', false);

% Barabasi-Albert: Preferential Attachment Graph Model (*@\index{Graphs!Barabasi-Albert}@*)
m0 = 3; % Size of the initial complete graph
ba  = grasp_barabasi_albert(N, m0);

% Random Bipartite
M = 20; % Size of the second set of nodes
rb  = grasp_random_bipartite(N, M, 'p', p);

% Random Regular
k = 3; % Degree
rr = grasp_random_regular(N, k);
