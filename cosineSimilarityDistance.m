function dist = cosineSimilarityDistance(xn,W)
    dist = dot(xn,W)/(norm(xn,2)*norm(W,2));
end