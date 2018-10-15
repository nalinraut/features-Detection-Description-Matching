
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
threshold = 0.8;

num_features = min(size(features1, 1), size(features2,1));
matches = [];
confidences = [];

for i=1:size(features1,1)
    
    f1 = features1(i,:);
    
    firstNearest = 99999;
    secondNearest = 99999;
    
    nearestIndex = -1;
    
    for j=1:size(features2,1)
        
        f2 = features2(j,:);
        
        diff = f1-f2;
        squared = diff.^2;
        dist = sqrt(sum(squared));
        
        if dist < firstNearest
            firstNearest = dist;
            nearestIndex = j;
        elseif dist < secondNearest
            secondNearest = dist;
        end
        
    end
    
    NNDR = firstNearest / secondNearest;
    
    if NNDR < threshold
        match = [i nearestIndex];
        matches = cat(1,matches,match);
        confidences = cat(1,confidences,(100*NNDR));
    end
    
end

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);

end