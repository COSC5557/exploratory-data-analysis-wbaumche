close all;
clear;
clc

%% Import Data
% Import white wine data
white = readmatrix('winequality-white.csv');
% Get dimensions
[obs,n] = size(white);

% Observe correlation between variables:
stringg=["fixed acidity","volatile acidity","citric acid","residual sugar","chlorides","free sulfur dioxide","total sulfur dioxide","density","pH","sulphates","alcohol"];
Corr = corrcoef(white(:,1:11));
% Plot with heatmap
figure(14)
h=heatmap(rescale(Corr,-1,1));
h.XData = stringg;
h.YData = stringg;
title('Correlation of Variables')

% Observe variance in quality with respect to each of the possible sets of
% variables
% WARNING: Not scaling correctly
fig = figure(20);
for i = 1:n-1
    for j = 1:n-1
        subplot(11,11,((i-1)*11 + j));
        if j <= i
            k=3;
            whitea = white(:,i);
            whiteb = white(:,j);
            kiwhit = whitea(white(:,12)==k);
            kjwhit = whiteb(white(:,12)==k);
            scatter(kiwhit,kjwhit);
            hold on
            for k = 4:9
                whitea = white(:,i);
                whiteb = white(:,j);
                kiwhit = whitea(white(:,12)==k);
                kjwhit = whiteb(white(:,12)==k);
                scatter(kiwhit,kjwhit);
            end
            hold off
        end
    end
end

%% PCA
% Conduct Principle Component Analysis on the white wine data
[coeff,scoreTrain,~,~,explained,mu] = pca(white(:,1:11));
% Find range of components giving 90% accuracy:
explained
% As can be seen, two components are sufficient, as the first two are ~98%
% responsible for variation in data
whitetra = (white(:,1:11)-mu)*coeff(:,1:2);
% Compute error between function-computed data and hand-calculated data
sum(sum(scoreTrain(:,1:2)-whitetra))

% Investigate coefficient correlation amongst PCA components
Corr = corrcoef(scoreTrain);
% Plot on heatmap
figure(15)
h=heatmap(rescale(Corr,-1,1));
h.XData = stringg;
h.YData = stringg;
title('Correlation of PCA Components')

%% Normalization
% Normalize the data - with a mean of zero and standard deviation of 1
normwhite = normalize(white);
% Plot distribution of normalized and unnormalized data
figure(1);
for i = 1:n-1
    subplot(3,4,i)
    histogram(normwhite(:,i),obs/2);
    title(['Normalized Data for ',stringg(i)]);
end
figure(2)
for i = 1:n-1
    subplot(3,4,i)
    histogram(white(:,i),obs/2);
    title(['Unnormalized Data for ',stringg(i)]);
end
% Also, plot boxplots to explore other variation of normalized data
figure(3)
subplot(1,2,1)
boxplot(white(:,1:11))
xlabel('Variable #')
title('Unnormalized Data')
subplot(1,2,2)
boxplot(normwhite(:,1:11))
xlabel('Variable #')
title('Normalized Data')

%% Rescaling
% Conduct rescaling on the data - to bounds of zero and one
normwhite = rescale(white);
% Plot distribution of normalized and unnormalized data
figure(4);
for i = 1:n-1
    subplot(3,4,i)
    histogram(normwhite(:,i),obs/2);
    title(['Scaled Data for ',stringg(i)]);
end
figure(5)
for i = 1:n-1
    subplot(3,4,i)
    histogram(white(:,i),obs/2);
    title(['Unscaled Data for ',stringg(i)]);
end
% Also, plot boxplots to explore other variation of normalized data
figure(6)
subplot(1,2,1)
boxplot(white(:,1:11))
xlabel('Variable #')
title('Unscaled Data')
subplot(1,2,2)
boxplot(normwhite(:,1:11))
xlabel('Variable #')
title('Scaled Data')
