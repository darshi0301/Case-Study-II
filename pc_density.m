%pc_density.m
function [p] = pc_density(x, xe, h)
p = zeros(size(x));
for i = 1:length(x)
 temp = 0; 
 
 for j = 1:length(xe)
 if (i ~= j) % Only calculate temp if i is not equal to j
 temp = temp + kernel((x(i) - xe(j)) / h);
 end
 end
 
 p(i) = temp / (length(xe) * h);
end
end