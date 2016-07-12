function [U,V,result]=parallelALSvv(D,params)
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
    U=updateUvv(D,V,U0,paramsUV);
    
    % updateV
    V0=V;
    V=updateVvv(D,U,V0,paramsUV);
    
    time=toc;
    %
    t=t+1;
    
    % record results
    result.time=[result.time,time];
    result.iter=[result.iter,t];
    loss=1.0/sqrt(M*N)*norm(D-U*V, 'fro' );
    result.loss=[result.loss,loss];
    
    fprintf('parallelALSvv...iterations...%s...times ...Loss...%s...\n\n', num2str(t),num2str(loss));
end



end