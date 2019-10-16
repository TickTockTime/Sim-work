%% direct trust function
function [RT] = RTRUST(T, State, Pos)
[n, len]=size(State);
count=0;
s=0;
for i=1:len
    if State(i)==State(Pos) && i~=Pos
        count=count+1;
        if Pos>i
            s=s+T(i, Pos);
        else
            s=s+T(Pos, i);
        end
    end
end
% ���ͬһ��û�������ڵ㣬�������ֵΪ0
if count==0
    RT=0;
else
    RT=s/count;
end
end