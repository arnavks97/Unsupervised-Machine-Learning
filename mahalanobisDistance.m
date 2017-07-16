function dist = mahalanobisDistance(xn,W)
    dist = sqrt((xn-W)'/(cov(xn-W))*(xn-W));
end