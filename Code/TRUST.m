%% trust function
function [trust] = TRUST(alpha, beta, N_s, N_d,Thn, T, State, Pos)

RW=0.2*N_s/N_d;
U=N_s/N_d;
DT=DTRUST(U,0.5,0.5);
if N_d<Thn
    RT=RTRUST(T, State, Pos);
    trust=alpha/(alpha+beta)*DT+beta/(alpha+beta)*RT+RW;
elseif N_d>=Thn
    trust=DT+RW;
end

if trust>1
    trust=1;
end

end