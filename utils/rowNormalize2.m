function matrix=rowNormalize2(matrix)
[M,~]=size(matrix);
for m=1:M
    row_m=sqrt(sum(matrix(m,:).^2));
    matrix(m,:)=matrix(m,:)./(row_m+eps);
end
end