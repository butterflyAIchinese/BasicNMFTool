function V=updateVvv(D,U,V0,params)
%
precision=params.precision;
maxIter=params.maxIter;

%
[M,N]=size(D);
[~,K]=size(U);

S=U'*U;
R=D'*U;

V=V0;

for n=1:N
%    v_pre=V(:,n);
    
%    t=0;
    %while(t<maxIter)
        % 
        for j=1:K
            %
            temp=0.0;
            for l=1:K
                if(l~=j)
                    temp=temp+V(l,n)*S(l,j);
                end
            end
            
            V(j,n)=max(0,(R(n,j)-temp)/(S(j,j)+eps));
        end
        
        %
  %      t=t+1;
  %     loss=max(abs(V(:,n)-v_pre));
  %      v_pre=V(:,n);
        
        %
       % if loss<precision
       %     break;
       % end
        
    %end
end


end