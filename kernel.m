%kernel.m 
function k=kernel(u)
if ((u<1)&(u>-1)) 
 k = (3.0/4)*(1-u*u);
else 
 k=0.0;
end
