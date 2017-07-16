clear all;
close all;
clc;

load pdata.data

pdata(:,9) = [];

x = pdata';
distM = squareform(pdist(pdata)); %For calculating dunn's index %nPoints*nPoints Matrix : distace of each to point to each other point
di = zeros(1,10);

mem = zeros(768,5);
mem(:,1) = 1;

%for generating 1 cluter bandwidth has to be high
    bandwidth = 170 %No. of cluster will be 1

    [clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(x,bandwidth);
    numClust = length(clustMembsCell);

    %Plotting results of 1 cluster
    
        figure(numClust);
        hold on;
        myMembers = clustMembsCell{1};
        myClustCen = clustCent(:,1);
        plot(x(2,myMembers),x(5,myMembers),'o','MarkerSize',5)
        plot(myClustCen(2),myClustCen(5),'o','MArkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',10)
        title(numClust);




%This loop will iterate over bandwidth such that no. of clusters will be between 2 and 9 
for i = 80:10:160
    
bandwidth = i %To go from no. clusters=1 to 7

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
            plot(x(2,myMembers),x(5,myMembers),[cVec(k) 'o'],'MarkerSize',10)
            plot(myClustCen(2),myClustCen(5),'o','MarkerEdgeColor','k','MarkerFaceColor',cVec(k), 'MarkerSize',10)
            title(numClust);
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
di
%dbi = evalclusters(iris_dat, mem, 'DaviesBouldin');

figure(10);
plot(1:10,di);
title('Dunn index');
xlabel('No. of clusters');
ylabel('Dunn index');

%mem
