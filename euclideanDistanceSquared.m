function dist = euclideanDistanceSquared(xn,W)
    dist = norm(xn-W,2).^2;
end