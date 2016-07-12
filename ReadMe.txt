Standard NMF Series Algorithms:

data: Images/Texts
ORL-Faces: D(terms*objects),picRows,picCols

(1) Multiplicative Update (MU) 2
迭代乘子法：muOne（一次迭代），muHALF（根号迭代）：（以矩阵为单位更新）

(2) Alternative Least Square (ALS) 2
以列分块 parallelALS（以向量、元素为单位更新）

以谱分解方式分块 fastHALS（以向量为单位更新）

(3) Projected Gradient Descent (PGD) 1
投影梯度下降法：（以矩阵为单位更新）

(4) Interior Point Method (IPM) 1
内点梯度下降法（变尺度梯度，及适合的步长）：（以矩阵为单位更新）

(5) Quasi Newton Method (QNM) 2
拟牛顿法：（以矩阵为单位更新）