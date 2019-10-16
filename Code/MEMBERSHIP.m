%% memership function
function [miu] = MEMBERSHIP(x, t, a)

if x>=0 && x<=(a+1)/2
    miu=((x-t)/(1-t))^2;
elseif x>(a+1)/2 && x<=1
    miu=1-((x-t)/(1-t))^2;
else
    miu=inf;
end

end