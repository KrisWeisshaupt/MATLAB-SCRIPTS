clear all;
close all;
clc;
FigHandle = figure('Position', [0, 0, 2400, 2400]);

hold on;
textured = 0;




if textured
    sample='102468 Textured';
    load('tex.mat')
    rof=tex-mean(mean(tex));
   
    rof = fliplr(rof);
    rof = rof';
    [m,n]=size(rof);
    extentX=3502;
    extentY=3524;
else
    sample='102469 Untextured';
    load('untex.mat')
    [m,n]=size(untex);
    %untex=untex(round(m*0.125):m,round(n*0.125):n);
    rof=untex-mean(mean(untex));
        rof = fliplr(rof);
    rof = rof';
    [m,n]=size(rof);

    extentX=round(4068);
    extentY=round(4109);
    %extentX=round(4068*0.875);
    %extentY=round(4109*0.875);
end;

xS=0:extentX/(n-1):extentX;
yS=0:extentY/(m-1):extentY;

% sample='16.192-02';
% load('S2.mat')
% rof=S2;
% [m,n]=size(rof);
% xS=0:12.4/(n-1):12.4;
% yS=0:1.54/(m-1):1.54;
%
% sample='16.192-01';
% load('S1.mat')
% rof=S1;
% [m,n]=size(rof);
% xS=0:12.4/(n-1):12.4;
% yS=0:1.85/(m-1):1.85;


%m1=14;
%m2=28;
%prof(14:28,:);

[y, x] = meshgrid(1:n, 1:m);
%z = rof;
%0.658205*x+726.259*y-41431; % filler data; this would be your A matrix
%X = [ones(m*n, 1), x(:), y(:)];
%M = X\z(:);

x=xS;
y=yS;

%%surf(x, y, z, 'EdgeAlpha',0.05); %'EdgeColor', 'none'); % original wavy data
%%hold all;
%%surf(x, y, reshape(X*M, m, n), 'EdgeColor', 'none', 'FaceColor', 'b'); % blue fitted-plane
%corr=rof-reshape(X*M, m, n);
%corr=corr+abs(min(min(corr)));
%%Figure;


%axis tight

% theta = -1.991*pi/180;
% x1=1;
% y1=1;
% a=[1,0,x1; 0,1,y1; 0,0,1];
% b = [cos(theta),-sin(theta),0; sin(theta),-cos(theta),0; 0,0,1];
% c = [1,0,-x1; 1,1,-y1; 0,0,1];
%
% M = c' * b *a';
%
%
% ry_angle=-1.991*pi/180;
% rx_angle = 1.782*pi/180;

%Ry = makehgtform('yrotate',ry_angle);
%Rx = makehgtform('yrotate',ry_angle);
%Rx=Rx(1:3,1:3);
%rof=rof*Rx;

surf(x,y,rof,'EdgeAlpha',0.0)
shading interp

%contourf(x,y,corr,'EdgeColor','none')
%bar3(x,y,corr)
xlim([0 max(x)]);
ylim([0 max(y)]);
zlim([-30 100]);
caxis([-27.5 27.5])
view(45,60)
xlabel('Circumferential Distance (µm)','FontSize', 12, 'FontWeight','bold');
ylabel('Axial Distance (µm)','FontSize', 12, 'FontWeight','bold');
zlabel('Depth (µm)','FontSize', 12, 'FontWeight','bold')


xh = get(gca,'XLabel'); % Handle of the x label
%set(xh, 'Units', 'Normalized')
pos = get(xh, 'Position');
%set(xh, 'Position',pos.*[0.8,-3.5,1],'Rotation',-21)
yh = get(gca,'YLabel'); % Handle of the y label
%set(yh, 'Units', 'Normalized')
pos = get(yh, 'Position');
%set(yh, 'Position',pos.*[1.15,2.75,1],'Rotation',22)

colormap jet
view(0,90)
axis equal

title(sample,'FontSize', 14);
colorbar
h = colorbar;
set(get(h,'label'),'string','Depth (µm)');

grid on
%ylabel(h, 'Depth (µm)');  %'Depth (Å)'


%  RESULTS = [RESULTS; {filename(1:length(filename)-4), abs(flattened(eCut)/10^4), 180/pi*atan(bCut(2)/10^7)}];

%     plot(lat, depth, '--g')
%     plot(lat, flattened, 'b','LineWidth',2)
%     plot(lat(s-2.5*flat:s), ending(s-2.5*flat:s), '--k')
%     plot(lat(c-2*cut:c+cut), cutLine(c-2*cut:c+cut), '--r')
%     hold off;
%     legend('Original', 'Angle Corrected', 'Surface', 'Cut Slope')
%     xlabel('Lateral Distance (mm)')
%     ylabel(strcat('Depth (',[char(197)],')'))
%     title(filename(1:length(filename)-4))
%     text(lat(c-0.5*cut),1.2*flattened(c-0.5*cut),char('Cut Slope:', strcat(num2str(bCut(2)/10000,4),' (µm/mm)'), strcat(num2str(180/pi*atan(bCut(2)/10^7),4),'°')),'VerticalAlignment','top');
%     text(lat(eCut),flattened(eCut)+50000,char('Paint Depth:', strcat(num2str(abs(flattened(eCut)/10^4),4),' (µm)')),'HorizontalAlignment','center','VerticalAlignment','bottom');
%
%
%     set(gca,'LooseInset',get(gca,'TightInset'))
%
%     shg
%     hgexport(gcf,strcat(filename(1:length(filename)-4),'.png'),hgexport('factorystyle'),'Format','png')
%
%     set(gcf,'PaperOrientation','landscape');
%     print(gcf, '-fillpage', '-dpdf', strcat(filename(1:length(filename)-4),'.pdf'))
%     RESULTS = [RESULTS; {filename(1:length(filename)-4), abs(flattened(eCut)/10^4), 180/pi*atan(bCut(2)/10^7)}];
% end







%xC=y';
%yC=corr(:,2000)/1000;

% hold on
% plot(xC,yC,'LineWidth',2)

%  mx = mean(xC);
%  my = mean(yC);
%  X = xC - mx; Y = yC - my; % Get differences from means
%  dx2 = mean(X.^2); dy2 = mean(Y.^2); % Get variances
%  t = [X,Y]\(X.^2-dx2+Y.^2-dy2)/2; % Solve least mean squares problem
%  a0 = t(1); b0 = t(2); % t is the 2 x 1 solution array [a0;b0]
%  r = sqrt(dx2+dy2+a0^2+b0^2); % Calculate the radius
%  a = a0 + mx; b = b0 + my; % Locate the circle's center
%  curv = 1/r; % Get the curvature
%
% th = 0:pi/500:2*pi;
% xunit = r * cos(th) + a;
% yunit = r * sin(th) + b;
%line(ones(length(th),1).*x(2000), xunit, yunit*1000,'Color','k','LineWidth',1)

%plot(xunit, yunit);
%axis equal

%axis([0 13 0 2 50 190])

hold off;


set(gca,'LooseInset',get(gca,'TightInset'))
shg
hgexport(gcf,strcat(sample,'.png'),hgexport('factorystyle'),'Format','png')

set(gcf,'PaperOrientation','landscape');
%print(gcf, '-fillpage', '-dpdf','-r600', strcat(sample,'.pdf'))




