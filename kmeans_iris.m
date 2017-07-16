clc;
clear all;
close all;

data   = load('iris_dat.dat');

f1 = data(:, 1);
f2 = data(:, 2);
f3 = data(:, 3);
f4 = data(:, 4);
acluster = data(:, 5);

features_data = [f1 f2 f3 f4];

%% Initialize variables for K-means algorithm
K = 3;                                                              % Number of clusters
K_iterations = 50;                                                  % Number of iterarions

centroids = zeros(K,max(size(features_data(1,:))));                                         
centroids(1,:) = features_data(ceil(rand(1)*50),:);                 % Selecting a random centroid for the first 50 samples
centroids(2,:) = features_data(ceil((rand(1)*50)+50),:);            % Selecting a random centroid for 50-100 samples
centroids(3,:) = features_data(ceil((rand(1)*50)+100),:);           % Selecting a random centroid for 100-150 samples

DaC = zeros(size(features_data,1),K+2);                          % Distance from centroids and cluster numbers
CV  = '+r.bxg';                                                     % Color vector

%% K-means 

for n=1:K_iterations                                                % Looping through the number of iterations
    for i=1:size(features_data(:,1))                                % Loop to process data of each sample            
        for j=1:K                                                   
            DaC(i,j) = norm(features_data(i,:) - centroids(j,:));   % Find the distance from the centroid of each cluster
        end
        
        [min_dist cno] = min(DaC(i,1:K));
        DaC(i,K+1) = cno;
        DaC(i,K+2) = min_dist;
    end
    
    for i=1:K
        A = features_data(DaC(:,K+1)==i,:);
        new_centroids = mean(A);
        if(new_centroids == centroids(i,:))
            continue
        else 
            centroids(i,:) = new_centroids;
        end
    end
end

%% Confusion Matrix
conf_mat = zeros(K,K);
for i=1:size(features_data(:,1))
    conf_mat(acluster(i,1),DaC(i,K+1)) = conf_mat(acluster(i,1),DaC(i,K+1)) + 1;
end
disp('Confusion Matrix -->');
disp(conf_mat);

disp('Individual Efficiency -->');
disp('For the first cluster - '); ie1 = max(conf_mat(1, :))/50
disp('For the second cluster - '); ie2 = max(conf_mat(2, :))/50
disp('For the third cluster - '); ie3 = max(conf_mat(3, :))/50

disp('Average Efficiency -->'); ae = (ie1 + ie2 + ie3)/3

disp('Overall Efficiency -->'); oe = (max(conf_mat(1, :)) + max(conf_mat(2, :)) + max(conf_mat(3, :)))/150

%% Plot graphs
for i=1:K
    points = features_data(DaC(:,K+1) == i,:);
    plot(points(:,1),points(:,2),CV(2*i-1:2*i));
    hold on;
    plot(centroids(:,1),centroids(:,2),'*k');
end
grid on;
figure;
for i=1:K
    points = features_data(DaC(:,K+1) == i,:);
    scatter3(points(:,1),points(:,2),points(:,3),'.');
    hold on;
    scatter3(centroids(:,1),centroids(:,2),centroids(:,3),'*');
end