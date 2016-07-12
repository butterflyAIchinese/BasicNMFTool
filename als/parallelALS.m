function [U,V,result]=parallelALS(D,params)
% initialize
U=params.Uinit;
V=params.Vinit;

% dimension
[M,N]=size(D);
[~,K]=size(U);

maxIter=params.maxIter;

result.iter=[];
result.loss=[];
result.time=[];

t=0;

paramsUV.maxIter=50;
paramsUV.precision=1.0e-3;


%
tic;

while(t<maxIter)
    % updateU
    U0=U;
    U=updateU2(D,V,U0,paramsUV);
    
    % updateV
    V0=V;
    V=updateV2(D,U,V0,paramsUV);
    
    time=toc;
    %
    t=t+1;
    
    % record results
    result.time=[result.time,time];
    result.iter=[result.iter,t];
    loss=1.0/sqrt(M*N)*norm(D-U*V, 'fro' );
    result.loss=[result.loss,loss];
    
    fprintf('parallelALS...iterations...%s...times ...Loss...%s...\n\n', num2str(t),num2str(loss));
end



end