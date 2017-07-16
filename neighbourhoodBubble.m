function neighDist = neighbourhoodBubble(Wij,Wbmu,sigma)
    if (sigma - (norm(Wij-Wbmu,2)))>=0
        neighDist = 1;
    else
        neighDist = 0;
end