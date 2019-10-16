%% check function
function [T_after]=CHECK(T_now, T_before, Eta, Err)
[n, len]=size(Err);
T_after=T_now;
for i=1:len
    if Err(i)~=0
        for node=1:len
            if node~=i
                delt_trust=T_now(min(node,i), max(node,i))-T_before(min(node,i), max(node,i));
                if delt_trust<0
                    T_after(min(node,i), max(node,i))=T_now(min(node,i), max(node,i))+Eta(Err(i))*delt_trust;
                else
                    T_after(min(node,i), max(node,i))=T_now(min(node,i), max(node,i))+1/Eta(Err(i))*delt_trust;
                end
            end
        end
    end
end

end