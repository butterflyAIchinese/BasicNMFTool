function matrix=colNormalize(matrix)
[m,~]=size(matrix);
matrix=matrix./(ones(m,1)*sqrt(sum(matrix.^2)));
end