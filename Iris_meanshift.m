clear all;
close all;
clc;

load iris_dat.dat

iris_dat(:,5) = [];

x = iris_dat';
distM = squareform(pdist(iris_dat)); %For calculating dunn's index %nPoints*nPoints Matrix : distace of each to point to each other point
di = zeros(1,10);

mem = zeros(150,9);
mem(:,1) = 1;

for i = 0.7:0.005:0.9
    
bandwidth = 1.6-i %To go from no. clusters=1 to 7

[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(x,bandwidth);

numClust = length(clustMembsCell);

%Plotting results for different number of clusters
if di(1,numClust) == 0
    figure(numClust);
    hold on;
    cVec = 'bgrcmykbgrcmykbgrcmykbgrcmyk';%, cVec = [cVec cVec];
    for k = 1:min(numClust, length(cVec))
        myMembers = clustMembsCell{k};
        myClustCen = clustCent(:,k);
        plot(x(1,myMembers),x(3,myMembers),[cVec(k) 'o'], 'MarkerSize',5)
        plot(myClustCen(1),myClustCen(3),'o','MarkerEdgeColor','k','MarkerFaceColor',cVec(k), 'MarkerSize',10)
    end
end

numClust
mem(:,numClust) = point2cluster';

%Validation(Duun's index and DBI index)
temp = dunns(numClust, distM, point2cluster);

if di(1,numClust) == 0
    di(1,numClust) = temp;
end

end

%dbi = evalclusters(iris_dat, mem, 'DaviesBouldin');
figure(10);
plot(1:10,di);
di
mem
dbi