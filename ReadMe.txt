Standard NMF Series Algorithms:

datasets: Images/Texts
ORL-Faces: D(terms*objects),picRows,picCols
RCV1: 29992*9625 (4 classes)
Reuters21578: 18933*8293
Sougou: 14921*2500
Caltech-256: 1024*29780
MNIST: 784*70000

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
