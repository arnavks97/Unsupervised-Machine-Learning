clc;
clear all;
close all;

training_file = imread('Landsat.jpg');

training_data = double( training_file(:,:,1));
final_data = [];
for i=1:size(training_file,2)
    final_data = cat(1,final_data,training_data(:,i,1));
end
final_image = zeros(size(training_data));
%% K-means clustering

K = 3;                                                              % Number of cluster
K_iterations = 1;                                                   % Number of iterations
DaC = zeros(size(final_data,1),K+2);                                % Distance and cluster labels
DaC(:,K+1) = 1;
centroids = [0;50;150];
%% K-means iterations

for n=1:K_iterations
    for i=1:size(final_data,1)
        row = mod(i,701);
        col = mod(i,600);
        if row==0
            row = 701;
        end
        if col==0
            col = 600;
        end
        min = abs(centroids(1) - training_data(row,col));
        final_image(row,col) = 1;
          
          for k=2:3
             temp = abs(centroids(k)-training_data(row,col));
              if temp<min
                  min = temp;
                  final_image(row,col) = k;
                  DaC(i,K+1) = k;
              end
          end
        
        DaC(i,K+2) = min;
    end

    for i = 1:K
      A = (DaC(:,K+1) == i);                          % Cluster K Points
      centroids(i,:) = mean(final_data(A,:));                      % New Cluster Centers
%       if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
%          NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
%          for Ind = 1:size(NC,1)
%          CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
%          end
%       end
   end
end

%% Setting intensitities for each cluster
for i=1:size(final_data)
    row = mod(i,701);
    col = mod(i,600);
    if row==0
        row = 701;
    end
    if col==0
        col = 600;
    end
    
    if DaC(i,K+1)==1
        final_image(row,col) = 0;
    elseif DaC(i,K+1)==2
        final_image(row,col) = 250;
    else
        final_image(row,col) = 250;
    end
end
figure(2);
im = mat2gray(final_image);
imshow(im);