y=[0.17 0.5 1.0 1.5 2.0 3.0];
surf(x(1:600),y',FTIR(1:600,:)','EdgeAlpha',0.1)
zlabel('Absorbance')
xlabel('Wavenumber cm^{-1}')
ylabel('Time (minutes)')
zlim([0,3.5])
%zlim([min(min(FTIR)),max(max(FTIR))])