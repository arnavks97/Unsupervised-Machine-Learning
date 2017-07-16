%% Clear screen and memory

clc;
clear all;
close all;

%% Initialise variables

input  = 4;                                         % Number of input neurons
output = 3;                                         % Number of output neurons
iterations   = 100;                                 % Number of iterations
learningRate = 1;                                 % Starting learning rate
sigma  = 10;                                        % Standard deviation
CV = '+r.bxg';

%% Load input data from file

file = load('iris_dat.dat');
trainingData = file(:,1:input);
targetData   = file(:,input+1:size(file,2));

samples = size(trainingData,1);
dist    = zeros(samples,output+2);

%% Initialize the weights
W = zeros(3,4);
W(1,:) = trainingData(ceil(rand(1)*50),1:input);                 % Selecting a random centroid for the first 50 samples
W(2,:) = trainingData(ceil((rand(1)*50)+50),1:input);            % Selecting a random centroid for 50-100 samples
W(3,:) = trainingData(ceil((rand(1)*50)+100),1:input);

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

%% Confusion Matrix
conf_mat = zeros(output,output);
for i=1:size(trainingData(:,1))
    conf_mat(targetData(i,1),dist(i,output+1)) = conf_mat(targetData(i,1),dist(i,output+1)) + 1;
end
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
   efficiency = (conf_mat(i,i)/50)*100;
   fprintf('Efficiency of cluster %d is %f%%\n',i,efficiency);
end

% Overall efficiency
sum = 0;
for i = 1:output
    sum = sum + conf_mat(i,i);
end
efficiency = (sum/150)*100;
fprintf('\nOverall efficiency is %f%%\n',efficiency);

% Average efficiency
sum_eff = 0;
for i = 1:output
    sum_eff = sum_eff + (conf_mat(i,i)/50);
end
efficiency = (sum_eff/output)*100;
fprintf('\nAverage efficiency is %f%%\n',efficiency);