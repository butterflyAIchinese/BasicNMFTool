function sp=matrixSparsity(matrix)
[M,N]=size(matrix);
zeroCount=sum(sum(matrix==0));
sp=zeroCount*1.0/(M*N);
end