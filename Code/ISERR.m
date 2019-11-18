function [result]=ISERR(attack, node)
    state=zeros(1, size(node, 2));
    for i=1:size(node, 2)
        if ismember(node(i), attack)
            state(i)=1;
        end
    end
    if state==ones(1, size(node, 2))
        result=1;
    else
        result=0;
    end
end