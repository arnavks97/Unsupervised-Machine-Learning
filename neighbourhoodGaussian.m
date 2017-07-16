function neighDist = neighbourhoodGaussian(Wij,Wbmu,sigma)
    neighDist = exp(-(norm(Wij-Wbmu,2).^2)/2*sigma*sigma);
end