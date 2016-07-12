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
dataLabel='Caltech-256';  %(Text) RCV1 20Newsgroup Reuters21578 Sougou %(Img)Caltech-256

if(strcmp(dataLabel,'RCV1'))
    load RCV1_4ClassV2.mat  % 29992*9625
    db_name='RCV1';
elseif((strcmp(dataLabel,'20Newsgroup')))
    load 20Newsgroup_Full.mat % 61188*18774 too big for single machine
    db_name='20Newsgroup';
elseif((strcmp(dataLabel,'Reuters21578')))
    load Reuters21578V2.mat % processed for program
    db_name='Reuters21578'; % 18933*8293
elseif((strcmp(dataLabel,'Sougou')))
    load Sougou.mat  % 14921*2500 
    db_name='Sougou';
elseif((strcmp(dataLabel,'Caltech-256')))
    load Caltech-256.mat  % 1024*29780
    db_name='Caltech-256';
else
    return;
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
%methods={'PGD'}  %RCV1 MNIST (stepsize)1.0e-4  ORL-faces (stepsize)1.0e-3
%Caltech-256 5.0e-5
nMethods=length(methods);

%% init params & run models
K=50; % 50 100 25
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
            % ORL-FACES: 
            % params.alpha=6.0e-3;
            % params.beta=6.0e-3;
            % MNIST:
            % params.alpha=1.0e-4;
            % params.beta=1.0e-4;
            % Caltech
            params.alpha=5.0e-5;
            params.beta=5.0e-5;
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

%%


