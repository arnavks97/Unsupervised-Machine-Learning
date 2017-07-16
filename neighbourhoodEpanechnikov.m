function neighDist = neighbourhoodEpanechnikov(Wij,Wbmu,sigma)
    neighDist = max(0,(1-(sigma - norm(Wij-Wbmu,2)).^2));
end