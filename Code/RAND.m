function [result]=RAND(node, N)
    result=zeros(1, node);
    count=1;
    while count~=node+1
        temp_node=randi([1,N],1);
        if ismember(temp_node, result)
            continue
        else
            result(count)=temp_node;
            count=count+1;
        end    
    end
    
    
end
