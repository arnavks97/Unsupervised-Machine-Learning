function neighDist = neighbourhoodCutGaussian(Wij,Wbmu,sigma)
    if (sigma - norm(Wij-Wbmu,2))>=0
        neighDist = exp(-(norm(Wij-Wbmu,2).^2)/2*sigma*sigma);
    else
        neighDist = 1;
end