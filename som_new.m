clear all;
close all;
clc;

dataTrain = load('iris_dat.dat');
cen = 3;
alpha = 1;
center = zeros(cen, 4);
x = dataTrain(:, 1);
y = dataTrain(:, 2);
[m, n] = size(dataTrain);
n = n - 1;
class = zeros(m, 3);
weight = zeros(n, cen);

for i = 1:4
    min1 = min(dataTrain(:, i));
    max1 = max(dataTrain(:, i));
    weight(i, :) = min1 + (max1 - min1)*rand(1, cen);
end


weight = transpose(weight);
for i = 1:m
    index = 0;
    alpha = 0.6;
    for ite = 1:1000
    
    min = 1000000;
    index = 0;
    for j = 1:cen
      d = norm(dataTrain(i, 1:4) - weight(j, :));
      d = d*d;
      if d < min
          min = d;
          index = j;
      end
    end
   
   for k = 1:n
       weight(index, k) = weight(index, k) + alpha*(dataTrain(i, k) - weight(index, k));
       alpha = alpha/2;
   end
   end
   for j = 1:cen
      d = norm(dataTrain(i, 1:4) - weight(j, :));
      if d < min
          min = d;
          index = j;
      end
   end
   if index == 1
       class(i, :) = [0 1 0];
   elseif index == 2
       class(i, :) = [0 0 1];
   else
       class(i,:) = [1 0 0];
   end
   weight
end
scatter(x, y, 30, class, 'filled');