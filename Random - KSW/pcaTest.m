

[coeff,score,latent,tsquared,explained,mu] = pca(beans');
%score=coeff*beans;
%score = score';
x=zscore(score(:,1));
y=zscore(score(:,2));
z=zscore(score(:,3));
gscatter3(x,y,z,group,{'b','r'},{'x','^'},8);

title(strvcat('PCA Elemental Composition of Coffee Beans', ['(', num2str(round(sum(explained(1:3))*10)/10), '% Explained by PCA axes 1-3)']));
xlabel(['PC1- (', num2str(round(explained(1))), '%)']);
ylabel(['PC2- (', num2str(round(explained(2))), '%)']);
zlabel(['PC3- (', num2str(round(explained(3))), '%)']);
legend('PanAnalytical 1', 'PanAnalytical 2');