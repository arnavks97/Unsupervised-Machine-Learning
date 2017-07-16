%% Clear screen and memory

clc;
clear all;
close all;

%% Initialise variables

input  = 8;                                         % Number of input neurons
output = 2;                                         % Number of output neurons
iterations   = 100;                                 % Number of iterations
learningRate = 1;                                   % Starting learning rate
sigma  = 10;                                        % Standard deviation
CV = '+r.bxg';

%% Load input data from file

file = load('pima_indian_diabetes.dat');
trainingData = file(:,1:input);
targetData   = file(:,size(file,2));
targetData = targetData+1;
samples = size(trainingData,1);
dist    = zeros(samples,output+2);

%% Initialize the weights
W = zeros(output,input);
for i=1:output
    if i==1
        W(1,:) = trainingData(ceil(rand(1)*(samples/output)),1:input);
    else
        W(i,:) = trainingData(ceil((rand(1)*(samples/output))+((samples/output)*(i-1))),1:input);
    end
end    

%% SOM

for epoch = 1:iterations
    for row = 1:samples
        for j = 1:output
            dist(row,j) = euclideanDistance(trainingData(row,:),W(j,:));
        end

        [min_dist BMU] = min(dist(row,1:output));
        dist(row,output+1) = BMU;
        dist(row,output+2) = min_dist;

        for j = 1:output
            W(j,:) = W(j,:) + learningRate*neighbourhoodGaussian(W(j,:),W(BMU,:),sigma)*(trainingData(row,:) - W(j,:));
        end

        learningRate = learningRate/(2);
        sigma = sigma/(2);
    end
end

final_W = round(W);
for row = 1:samples
        for j = 1:output
            dist(row,j) = euclideanDistance(trainingData(row,:),final_W(j,:));
        end

        [min_dist BMU] = min(dist(row,1:output));
        dist(row,output+1) = BMU;
        dist(row,output+2) = min_dist;
end
a = zeros(1,2)
for i =1:samples
    if dist(i,output+1)==1
        a(1,1) = a(1,1)+1;
    else
        a(1,2)=a(1,2)+1;
    end
end
a

%% Confusion Matrix
conf_mat = zeros(output,output);
for i=1:size(trainingData(:,1))
    conf_mat(targetData(i,1),dist(i,output+1)) = conf_mat(targetData(i,1),dist(i,output+1)) + 1;
end
fprintf('Confusion matrix: \n');
disp(conf_mat);

%% Plot graphs
for i=1:output
    points = trainingData(dist(:,output+1) == i,:);
    plot(points(:,1),points(:,2),CV(2*i-1:2*i));
    hold on;
    plot(W(:,1),W(:,2),'*k');
end
grid on;
figure;
for i=1:output
    points = trainingData(dist(:,output+1) == i,:);
    scatter3(points(:,1),points(:,2),points(:,3),'.');
    hold on;
    scatter3(W(:,1),W(:,2),W(:,3),'*');
end

%% Effeciencies

% Individual efficiency
for i = 1:output
   if i==1
   efficiency = (conf_mat(i,i)/500)*100;
   else
       efficiency = (conf_mat(i,i)/268)*100;
   end
   fprintf('Efficiency of cluster %d is %f%%\n',i,efficiency);
end

% Overall efficiency
sum = 0;
for i = 1:output
   if i==1
   sum_eff = (conf_mat(i,i)/500)*100;
   else
       sum_eff = (conf_mat(i,i)/268)*100;
   end
%    sum = sum + conf_mat(i,i);
end
sum_eff = (sum/768)*100;
fprintf('\nOverall efficiency is %f%%\n',efficiency);

% Average efficiency
sum_eff = 0;
for i = 1:output
    if i==1
        sum_eff = sum_eff + (conf_mat(i,i)/500)*100;
    else
        sum_eff = sum_eff + (conf_mat(i,i)/268)*100;
    end
end
efficiency = (sum_eff/output);
fprintf('\nAverage efficiency is %f%%\n',efficiency);