% clear and clc
clear;
clc;

%%
addpath('./utils/');
addpath('./mu/');
addpath('./als/');
addpath('./qnm/');
addpath('./pgd/');
addpath('./ipm/');
addpath('./ipg/');

% load data
addpath('./data/');
%load D_face_normalized.mat % D:M*N, picRows, picCols
dataLabel=0;
if(dataLabel==1)
    load D_face_normalized.mat
    db_name='ORL-FACES';
else
    load MNIST_colNormalizeR.mat
    db_name='MNIST';
end
    

[M,N]=size(D);

%%
% muONE: multiplicative update (*./*)
% muHALF: multiplicative update (sqrt(*./*))
% ALS: Alternative Least Squares
% fastHALS:
% PGD: projected gradient descent
% IPM: interior point method
% QNM: quasi newton method
%methods={'muOne','muHALF','fastHALS','SmoothQNM','QNM','PGD','parallelALS','IPG','IPM','parallelALSvv'};
% IPM parallelALSvv "not work very well"

methods={'muOne','muHALF','fastHALS','SmoothQNM','QNM','PGD','parallelALS','IPG'}
% methods={'parallelALS','parallelALSvv'}
nMethods=length(methods);

%% init params & run models
K=50; % 64 36 16 added 100 50 25
params.Uinit=colNormalize(rand(M,K));
params.Vinit=colNormalize(rand(K,N));
params.maxIter=500;

for i=1:nMethods
    switch(methods{i})
        % muOne
        case 'muOne'
            [U{i},V{i},result{i}]=muOne(D,params);  % result:loss,iter
        
            % muHALF
        case 'muHALF'
            [U{i},V{i},result{i}]=muHALF(D,params);
            
        case 'fastHALS'
            [U{i},V{i},result{i}]=fastHALS(D,params);
        
        case 'SmoothQNM'
           [U{i},V{i},result{i}]=QNM(D,params); 
           
        case 'QNM'
            [U{i},V{i},result{i}]=QNM3(D,params);
           
        case 'PGD'
            % ORL-FACES
            %params.alpha=6.0e-3;
            % params.beta=6.0e-3;
            % MNIST
            params.alpha=1.0e-3;
            params.beta=1.0e-3;
            [U{i},V{i},result{i}]=PGD(D,params); 
        
        case 'parallelALS'
            [U{i},V{i},result{i}]=parallelALS(D,params); 
            
        case 'IPM' % to be continued
            params.Uinit=params.Uinit+1;
            params.Vinit=params.Vinit+1;
            [U{i},V{i},result{i}]=IPM(D,params);
            
        case 'IPG'
            [U{i},V{i},result{i}]=IPG(D,params);
            
        case 'parallelALSvv' % to be continued
            [U{i},V{i},result{i}]=parallelALSvv(D,params);
    end   
end

%% plot attribution
line_width = 2;
marker_size = 8;
xy_font_size = 14;
legend_font_size = 12;
linewidth = 1.6;
title_font_size = xy_font_size;

%% loss v.s. iterations
figure('Color', [1 1 1]); hold on;

for j = 1: nMethods
    p = plot(result{j}.iter, result{j}.loss);
    color = gen_color(j);
    marker = gen_marker(j);
    set(p,'Color', color)
    set(p,'Marker', marker);
    set(p,'LineWidth', line_width);
    set(p,'MarkerSize', marker_size);
end

h1 = xlabel('Iterations');
h2 = ylabel('Loss');
title(db_name, 'FontSize', title_font_size);
set(h1, 'FontSize', xy_font_size);
set(h2, 'FontSize', xy_font_size);
axis square;
hleg = legend(methods);
set(hleg, 'FontSize', legend_font_size);
set(hleg,'Location', 'best');
set(gca, 'linewidth', linewidth);
box on; grid on; hold off;

%% loss v.s.time
figure('Color', [1 1 1]); hold on;

for j = 1: nMethods
    p = plot(result{j}.time, result{j}.loss);
    color = gen_color(j);
    marker = gen_marker(j);
    set(p,'Color', color)
    set(p,'Marker', marker);
    set(p,'LineWidth', line_width);
    set(p,'MarkerSize', marker_size);
end

h1 = xlabel('Time');
h2 = ylabel('Loss');
title(db_name, 'FontSize', title_font_size);
set(h1, 'FontSize', xy_font_size);
set(h2, 'FontSize', xy_font_size);
axis square;
hleg = legend(methods);
set(hleg, 'FontSize', legend_font_size);
set(hleg,'Location', 'best');
set(gca, 'linewidth', linewidth);
box on; grid on; hold off;




%% image basis

for j=1:nMethods
    figure
    [Urows,Ucols]=size(U{j});
    for i=1:Ucols   
        f=reshape(U{j}(:,i),picRows,picCols);
        subplot(sqrt(K),sqrt(K),i);
        if(dataLabel==1)
            imshow(mat2gray(f));  % digits transpose/faces not
        else
            imshow(mat2gray(f'));
        end
            
    end  
end


%%