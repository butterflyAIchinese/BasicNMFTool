function [U,V,result]=fastHALS(D,params)
%
U=params.Uinit;
V=params.Vinit;
maxIter=params.maxIter;

[M,N]=size(D);
[~,K]=size(U);

result.iter=[];
result.loss=[];
result.time=[];

t=0;

%
tic;
while(t<maxIter)
    % updateU
    A=D*V';
    B=V*V';
    for k=1:K
        U(:,k)=proj(U(:,k)+(A(:,k)-U*B(:,k))/(B(k,k)+eps));
    end
    
    % updateV
    C=U'*D;
    E=U'*U;
    for k=1:K
        V(k,:)=proj(V(k,:)+(C(k,:)-E(k,:)*V)/(E(k,k)+eps));
    end
    
    time=toc;
    %
    t=t+1;
    
    % record results
    result.time=[result.time,time];
    result.iter=[result.iter,t];
    loss=1.0/sqrt(M*N)*norm(D-U*V, 'fro' );
    result.loss=[result.loss,loss];
    
    fprintf('fastHALS...iterations...%s...times ...Loss...%s...\n\n', num2str(t),num2str(loss));
end

end