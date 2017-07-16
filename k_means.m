clc;
clear all;
close all;

f = load('iris_dat.dat');
f1 = f(:,1);
f2 = f(:,2);
f3 = f(:,3);
f4 = f(:,4);
F = [f1 f2 f3 f4];

k = 3;
iter = 100;
temp = ceil(rand(k, 1)*size(F, 1));
centroids = F(temp, :);
distance   = zeros(size(F, 1), k+2);
color    = '+r+b+c';

for n = 1:iter
    for i = 1:size(F,1)
        for j = 1:k
            distance(i, j) = norm(F(i, :) - centroids(j, :));
        end
        
        [Dist CN] = min(distance(i, 1:k));
        distance(i, k+1) = CN;
        distance(i, k+2) = Dist;
    end
    for i = 1:k
      A = (distance(:, k+1) == i);
      centroids(i, :) = mean(F(A, :));
      if sum(isnan(centroids(:))) ~= 0
         NC = find(isnan(centroids(:, 1)) == 1);
         for Ind = 1:size(NC, 1)
         centroids(NC(Ind), :) = F(randi(size(F, 1)), :);
         end
      end
    end
    
    clf
    figure(1)
    hold on

    for i = 1:k
        PT = F(distance(:, k+1) == i, :);   
        plot(PT(:, 1),PT(:, 2), color(2*i-1:2*i), 'LineWidth', 2);
        plot(centroids(:, 1), centroids(:, 2), '*k', 'LineWidth', 7);
    end

    hold off
    grid on
    pause(0.1)
end