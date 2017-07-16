clear all;
clc;
close all;
training_file = imread('Landsat.jpg');

training_data = double( training_file(:,:,1));

data = [];

for i=1:size(training_file,2)
    data = cat(1,data,training_data(:,i,1));
end

[m n] = size(data);
k=2;
mfuzz=2;
center=zeros(k,n);
c=0;
meu=rand(m,k+2);
for j=1:2
    for i=1:k
        num=zeros(1,n);
        den=zeros(1,n);
        for l=1:m
            num(1,:)=num(1,:)+(data(l,1:n).*(meu(l,i).*meu(l,i)));
            den(1,:)=den(1,:)+((meu(l,i).*(meu(l,i))));
        end
        center(i,:)=num(1,:)./den(1,:);
    end
    num=0;
    den=0;
    for i=1:m
        for l=1:k
            den=0;
            for d=1:k
                den=den+(((norm(data(i,1:size(data,2))-center(l,:))).^2)/((norm(data(i,1:size(data,2))-center(d,:))).^2));
            end
            meu(i,l)=1/den;
        end
    end
    c=c+1
    [max_prob cno] = max(meu(i,1:k));
    meu(i,k+1) = cno;
    meu(i,k+2) = max_prob;
end    

misplaced=0;

%% Setting intensitities for each cluster

m=0;
for i=1:size(training_data,1)
%    [maxval p] = max(meu(i,:));
    for l=1:size(training_file,2)
        m=m+1
            if (meu(:,k+1)==1)
                training_data(i,l) = 30;
            elseif (meu(:,k+2)==2)
                training_data(i,l) = 250;
            end
    end
end
image(training_data);
