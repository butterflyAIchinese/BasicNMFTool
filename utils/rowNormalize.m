function matrix=rowNormalize(matrix)
[~,n]=size(matrix);
matrix=matrix./(sqrt(sum(matrix.^2,2))*ones(1,n));
end