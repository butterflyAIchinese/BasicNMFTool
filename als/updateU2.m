function U=updateU2(D,V,U0,params)
%
precision=params.precision;
maxIter=params.maxIter;

%
[M,N]=size(D);
[K,~]=size(V);

S=V*V';
R=D*V';

U=U0;

for m=1:M
    %parallel_u=U(m,:);
    u_pre=U(m,:);
    
    t=0;
    while(t<maxIter)
        %
        for j=1:K
            %
            temp=0.0;
            for l=1:K
                if(l~=j)
                    temp=temp+U(m,l)*S(l,j);
                    %temp=temp+parallel_u(1,l)*S(l,j);
                end
            end
            
            U(m,j)=max(0,(R(m,j)-temp)/(S(j,j)+eps));
            %parallel_u(1,j)=max(0,(R(m,j)-temp)/(S(j,j)+eps));
        end
        
        %
        t=t+1;
        loss=max(abs(U(m,:)-u_pre));
        
        %U(m,:)=parallel_u;
        u_pre=U(m,:);
        
        %
        if loss<precision
            break;
        end
    end
end



end