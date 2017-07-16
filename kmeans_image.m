clc;
clear all;
close all;

training_file = imread('Landsat.jpg');

training_data = double( training_file(:,:,1));

final_data = [];

for i=1:size(training_file,2)
    final_data = cat(1,final_data,training_data(:,i,1));
end

%% K-means clustering

K = 2;                                                              % Number of cluster
K_iterations = 1;                                                  % Number of iterations
DaC = zeros(size(final_data,1),K+2);                                % Distance and cluster labels
centroids = final_data(ceil(rand(K,1)*size(final_data,1)),:);       % Centroids

%% K-means iterations

for n=1:K_iterations
    for i=1:size(final_data,1)
        for j=1:K
            DaC(i,j) = norm(final_data(i,:)-centroids(j,:));
        end
        
        [min_dist cno] = min(DaC(i,1:K));
        DaC(i,K+1) = cno;
        DaC(i,K+2) = min_dist;
    end
    
    for i = 1:K
      A = (DaC(:,K+1) == i);                          % Cluster K Points
      centroids(i,:) = mean(final_data(A,:));                      % New Cluster Centers
   end
end

%% Setting intensitities for each cluster

m=0;
for i=1:size(training_data,1)
    for l=1:size(training_file,2)
        m=m+1
            if (DaC(:,K+1)==1)
                training_data(i,l) = 30;
            elseif (DaC(:,K+1)==2)
                training_data(i,l) = 250;
            end
    end
end
image(training_data);