clear all;
clc;
close all;

data = load('iris_dat.dat');
[m n] = size(data);
k = 3;
mfuzz = 2;
center = zeros(k, 4);

meu = rand(m, k);

for j = 1:10
    for i = 1:k
        num = zeros(1, 4);
        den = zeros(1, 4);
        for l = 1:m
            num(1, :) = num(1, :) + (data(l, 1:4).*(meu(l, i)*meu(l, i)));
            den(1, :) = den(1, :) + ((meu(l, i).*(meu(l, i))));
        end
        center(i, :)=num(1, :)./den(1, :);
    end
    for i = 1:m
        for l = 1:k
            den = 0;
            for d = 1:k
                den = den + (((norm(data(i, 1:4) - center(l, :))).^2)/((norm(data(i, 1:4)-center(d, :))).^2));
            end
            meu(i, l) = 1/den;
        end
    end
end    

confusion = zeros(k, k);
for i = 1:150

    pos = 0;
    
       [maxval p] = max(meu(i, :));
            confusion(data(i, 5), p) = confusion(data(i, 5), p) + 1;
end
%meu
disp('Confusion Matrix -->'); confusion

disp('Individual Efficiency -->');
disp('For the first cluster - '); ie1 = max(confusion(1, :))/50
disp('For the second cluster - '); ie2 = max(confusion(2, :))/50
disp('For the third cluster - '); ie3 = max(confusion(3, :))/50

disp('Average Efficiency -->'); ae = (ie1 + ie2 + ie3)/3

disp('Overall Efficiency -->'); oe = (max(confusion(1, :)) + max(confusion(2, :)) + max(confusion(3, :)))/150
