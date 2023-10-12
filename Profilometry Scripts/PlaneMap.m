%load('prof.mat')
%m1=14;
%m2=28;
rof=CA;
%rof=prof(14:28,:);
[m,n]=size(rof);
[y, x] = meshgrid(1:n, 1:m);
%rof=fliplr(rof);
%rof=flipud(rof);

z = rof;
%0.658205*x+726.259*y-41431; % filler data; this would be your A matrix
X = [ones(m*n, 1), x(:), y(:)];
M = X\z(:);

 extentY=3;
 extentX=3;
 
 x=fliplr(0:extentX/(n-1):extentX);
 y=0:extentY/(m-1):extentY;
 %x=flip
 
%x=0:1/20:n/20-1/20;
%y=0:1:m-1;

%%surf(x, y, z, 'EdgeAlpha',0.05); %'EdgeColor', 'none'); % original wavy data
%%hold all;
%%surf(x, y, reshape(X*M, m, n), 'EdgeColor', 'none', 'FaceColor', 'b'); % blue fitted-plane
corr=rof-reshape(X*M, m, n);
corr=corr./54;%/112;
subplot(2,1,1:2)
surf(x, y, corr, 'EdgeColor', [0 0 0], 'LineWidth',0.25, 'EdgeAlpha', 0.0);%'FaceColor', 'b')
xlabel('Distance (mm)');
ylabel('Distance (mm)');
zlabel('Height (µm)');
axis([0 3 0 3])


% subplot(2,1,2)
% imagesc(y, x, corr')%, 'EdgeColor', [0 0 0], 'EdgeAlpha', 0.05);%'FaceColor', 'b')
% %%Figure;
% %contourf(x,y,corr)
% %bar3(x,y,corr)
% axis tight
% xlabel('Distance (mm)');
% ylabel('Distance (mm)');
% 
% colorbar
% h = colorbar;
% ylabel(h, 'Depth (\mum)');
% %set(gca,'Ydir','reverse')
% %set(gca,'Xdir','reverse')
% colormap jet
shg