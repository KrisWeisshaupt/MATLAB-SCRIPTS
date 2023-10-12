%function [processed]= ProcessFile(file,blankFile,standardFile)
%% Find Peaks in Alkane Standard
%ProcessFile('102317 20dil.csv','Toluene Blank2.csv','n-alkanes Longer.csv')
%file='102515 Distillation Residue.csv';
%blankFile='IPA Blank 5.csv';
%standardFile='n-alkanes.csv';
%data = obj.import('.D','precision',0);

chrom = Chromatography();
sampleData = chrom.import('.D','precision',0);
blankData = chrom.import('.D','precision',0);
alkanesData = chrom.import('.D','precision',0);

sample = sampleData(1).tic.values;
blank = blankData(1).tic.values;
alkanes= alkanesData(1).tic.values;

sample=[zeros(length(alkanes)-length(sample),1); sample];
blank=[zeros(length(alkanes)-length(blank),1); blank];

sampleOld=sample;

sample = sample-blank;%- 0.8.*blank;
%sample(1:400)=0;
alkanes=alkanes;%-(blank);
sampleTitle=sampleData.sample.name;
alkaneTitle=alkanesData.sample.name;
time=alkanesData.time;
%sample(1:718)=0;

%axis([0,100,0,450]);
% figure(1);  clf;
% whitebg('white');
% set(gcf,'color','white');
% hfig = figure(1);
% FigPos=[100 100 1000 800];
% set(hfig, 'Position', FigPos)
% ax=gca;
%
%     delimiter = ',';
%     startRow = 6;
% formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
%
% fileID = fopen(file,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
%   fclose(fileID);
%   MS = [dataArray{1:end-1}];
%   sample=sum(MS,2);
%
% fileID = fopen(blankFile,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
%   fclose(fileID);
%   MS = [dataArray{1:end-1}];
%   blank=sum(MS,2);
%
% fileID = fopen(standardFile,'r');
%
%        sample = sample - blank;
%         sampleTitle=file(1:length(file)-4);
%         alkaneTitle='08072022';
%
%
%         %% Read columns of data according to format string.
%         % This call is based on the structure of the file used to generate this
%         % code. If an error occurs for a different file, try regenerating the code
%         % from the Import Tool.
%         dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
%
%         %% Close the text file.
%         fclose(fileID);
%
%         %% Post processing for unimportable data.
%         % No unimportable data rules were applied during the import, so no post
%         % processing code is included. To generate code which works for
%         % unimportable data, select unimportable cells in a file and regenerate the
%         % script.
%
%         %% Create output variable
%         MS = [dataArray{1:end-1}];
%         time= 3.087:(16.315-3.087)/(size(MS,1)-1):16.315;
TIC=alkanes;
%alkanes=TIC;


PeakSig = TIC;       % a subsection that's got a few peaks...
x=time;             % corollary variable of bin locations
minProminence=max(PeakSig)*0.05;
minDistance=0.05;
[pks,locs,wdths,border]=findpeaks(PeakSig,time,'MinPeakProminence',minProminence,'MinPeakDistance',minDistance,'Annotate','extents','WidthReference','halfheight');
left=locs;
right=locs;

%fnInterpL=@(p,l,w) interp1(PeakSig(l-w:l),l-w:l,0.2*p);  % interpolate lower side
%fnInterpH=@(p,l,w) interp1(PeakSig(l:l+w),l:l+w,0.2*p);  % and upper...
%[arrayfun(fnInterpL,pks,locs.',wdths.') arrayfun(fnInterpH,pks,locs.',wdths.')]

%fnInterpL=@(p,l,w) interp1(PeakSig(l-w:l),l-w:l,0.2*p);  % interpolate lower side


labels = {'n-C5', 'n-C6', 'n-C7', 'n-C8', 'n-C9', 'n-C10', 'n-C11', 'n-C12', 'n-C14', 'n-C15', 'n-C16', 'n-C17', 'n-C18', 'n-C20', 'n-C24', 'n-C28', 'n-C32', 'n-C36', 'n-C40', 'n-C44'};
C=[5 6 7 8 9 10 11 12 14 15 16 17 18 20 24 28 32 36 40 44]';
bp=[36 69 98 126 151 174 196 216 254 271 287 302 316 344 391 431 466 496 522 545]';

labels=labels(4:18);
C=C(4:18);
bp=bp(4:18);
% for i = 1:length(locs)
%     % interpolate left
%     cIndex=find(x==locs(i));
%     
%     while PeakSig(cIndex) >= .1*pks(i) && cIndex >= 2
%         cIndex = cIndex - 1;
%     end
%     left(i) = cIndex;
%     cIndex=find(x==locs(i));
%     %PeakSig(left(i))/pks(i)
%     left(i)=sum(PeakSig(left(i):cIndex));
%     
%     
%     
%     % interpolate right
%     cIndex=find(x==locs(i));
%     while PeakSig(cIndex) >= 0.1*pks(i) && cIndex <= length(PeakSig)
%         cIndex = cIndex + 1;
%     end
%     right(i) = cIndex;
%     cIndex=find(x==locs(i));
%     right(i)=sum(PeakSig(cIndex:right(i)));
% end

skew=right./left;
resolution=2*(locs(find(C==18))-locs(find(C==16)))/(1.699*(wdths(find(C==18))+wdths(find(C==16))));


%Calulating Sample Offset 12.2.1
% Use the first second worth of data

avg=mean(sample(1:find(time>0.0167,1)));
stdev=std(sample(1:find(time>0.0167,1)));

tot=0;
num=0;

% Ignore any data points that are futher than one standard deviation from
% the mean
for i= 1:find(time>0.0167,1)-1
    if(abs(sample(i)-avg)<=stdev)
        tot=tot+sample(i);
        num=num+1;
    end
end

offset=0;

%Subtract the average slice offset from all the slices, set negative values to zero
sample=sample-offset;
sample=max(0,sample);


%Calulating Blank Offset 12.2.2.1
% Use the first second worth of data
avg=mean(blank(1:find(time>0.0167,1)));
stdev=std(blank(1:find(time>0.0167,1)));

tot=0;
num=0;

% Ignore any data points that are futher than one standard deviation from
% the mean
for i= 1:find(time>0.0167,1)-1
    if(abs(blank(i)-avg)<=stdev)
        tot=tot+blank(i);
        num=num+1;
    end
end

offset=0;

%Subtract the average slive offset from all the slices, set negative values to zero
blank=blank-offset;
blank=max(0,blank);

%Computing the Average Slice Width
sliceWidth=time;
for i= 1:length(time)-1
    sliceWidth(i)=time(i+1)-time(i);
end
sliceWidth(length(time))=sliceWidth(length(time)-1);
sliceWidth=mean(sliceWidth);

%Subtract the baseline corrected blank from the baseline corrected sample.
sample=sample-0.8*blank;
sample=max(0,sample);


%12.4 Determine the Start and End of Sample Elution Time
%Calculate the Total Area
totalArea=sum(sample)*sliceWidth;

% Determine the area of each second of data
timeSeconds=time*60;
secondsArea=zeros(floor(max(timeSeconds)),1);
for i=1:length(secondsArea)
    secondsArea(i)=sum(sample(find(timeSeconds>=i-1,1):find(timeSeconds>=i,1)-1))*sliceWidth;
end

% The time where the rate of change first exceeds 0.00001% per second of the total area
startElution=2;
while 100*(secondsArea(startElution)-secondsArea(startElution-1))/totalArea<0.00001
    startElution=startElution+1;
end

% The time where the rate of change last exceeds 0.00001% per second of the total area
endElution=length(secondsArea)-1;
while 100*(secondsArea(endElution)-secondsArea(endElution+1))/totalArea<0.00001
    endElution=endElution-1;
end

%12.6 Calculate the Sample Total Area
%(integrate between elution start and elution end)
totalArea=sum(sample(find(timeSeconds>=startElution,1):find(timeSeconds>=endElution,1)-1));

%12.7 Normalize to Area Percent
samplePercents=sample./totalArea*100;
cumulativePercents=samplePercents;

for i=1:length(cumulativePercents)
    cumulativePercents(i)=sum(samplePercents(1:i));
end

%12.8.1 Initial Boiling Point (0.5%)
%12.8.2 Final Boiling Point (99.5%)
%12.8.3 Intermediate Boiling Points (1-99%)
% points=cat(2, 0.5, [1:1:99], 99.5)';
% bPoints=zeros(length(points),1);
%
% for i=1:length(points)
%     %12.9.1 Interpolate the sample chromatogram to find exact time (rTime)
%     %where the %Recovery will equal the percentage specified by points(i)
%     rLoc=find(cumulativePercents<=points(i),1,'last');
%     ts=time(rLoc);
%     ax=(points(i)-cumulativePercents(rLoc))/(cumulativePercents(rLoc+1)-cumulativePercents(rLoc));
%     tf=ax*sliceWidth;
%     rTime=ts+tf;
%     %12.9.2 Interpolate the n-alkanes curve to find the boiling point
%     %corresponding to rTime
%     rLoc=find(locs<=rTime,1,'last');
%     if isempty(rLoc)
%         m=(bp(2)-bp(1))/(locs(2)-locs(1));
%         bPoints(i)=m*(rTime-locs(1))+bp(1);
%     elseif rLoc==length(locs)
%         m=(bp(rLoc)-bp(rLoc-1))/(locs(rLoc)-locs(rLoc-1));
%         bPoints(i)=m*(rTime-locs(rLoc-1))+bp(rLoc-1);
%     else
%         m=(bp(rLoc+1)-bp(rLoc))/(locs(rLoc+1)-locs(rLoc));
%         bPoints(i)=m*(rTime-locs(rLoc))+bp(rLoc);
%     end
%     %round to nearest 0.5
%     bPoints(i)=round(bPoints(i) * 2)/2;
% end

%%Check Response Factor of n-Alkanes
areas=(0:numel(pks)-1)';

alkanesBaselined=msbackadj(time,alkanes,'WindowSize',0.25,'StepSize',0.25,'ShowPlot',0);
for i=1:length(areas)
    lb=find(time>locs(i)-wdths(i),1);
    ub=find(time>locs(i)+wdths(i),1);
    areas(i)=trapz(alkanesBaselined(lb:ub))*sliceWidth;
end
responseFactor=zeros(length(areas),1);
for i=1:length(responseFactor)
    responseFactor(i)=(1/areas(i))/(1/areas(find(C==10,1)));
end


%% Plot n-alkanes Chromatogram
figure(1);  clf;
whitebg('white');
set(gcf,'color','white');
hfig = figure(1);
%set(hfig, 'Position', FigPos)
ax=gca;

findpeaks(PeakSig,time,'MinPeakProminence',minProminence,'MinPeakDistance',minDistance,'Annotate','extents','WidthReference','halfheight');

xlabel('Retention Time (minutes) | Top: n-alkane retention times');
ylabel("TIC");
maxY=max(PeakSig)*1.1;
xlim([2.5 max(time)]);
ylim([0 maxY]);
pks=pks';
text(locs,pks+(max(PeakSig)*0.02),labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
title(strcat(alkaneTitle, ' n-alkanes'))

% text(5.9,0.9*maxY,'Resolution:','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
% text(5.9,0.9*maxY-0.025*maxY,sprintf('%.3f',resolution),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
%
% text(21,0.8*maxY,'C#','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
% text(21.5,0.8*maxY,'Time (min)','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
% text(22,0.8*maxY,'Skew','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
% text(22.5,0.8*maxY,'Response Factor','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
% text(23,0.8*maxY,'%Deviation','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
%
% for i=1:length(C)
%     text(21,0.8*maxY-i*0.025*maxY,sprintf('n-C%.0f',C(i)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
%     text(21.5,0.8*maxY-i*0.025*maxY,sprintf('%.3f',locs(i)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
%     text(5.9,0.8*maxY-i*0.025*maxY,sprintf('%.3f',skew(i)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
%     text(6.6,0.8*maxY-i*0.025*maxY,sprintf('%.3f',responseFactor(i)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
%     text(7.4,0.8*maxY-i*0.025*maxY,sprintf('%.1f',(responseFactor(i)-1)*100),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
% end;

set(gca,'LooseInset',get(gca,'TightInset'))

set(gcf,'PaperOrientation','landscape');
print(gcf, '-fillpage', '-dpdf', strcat('n-alkanes - ',' ', alkaneTitle ,'.pdf'));




%% Plot Sample Chromatogram
figure(1); clf;
maxY=max(sample*1.1);
if(maxY==0)
    sample(1)=100;
end
maxY=max(sample*1.1);
hold on
xlabel('Retention Time (minutes) | Top: n-alkane retention times');
ylabel("TIC");

axis([2.5,max(time),0,maxY]);
set(gca,'XTick',0:17);
title(strcat(sampleTitle, ' '))
for i=1:length(locs)
    if C(i)~=6 && C(i)~=7
        plot([locs(i),locs(i)],[0,maxY],'k','color', [0,0,0]+0.85);
        text(locs(i),maxY*0.98,sprintf(' C%.0f',C(i)),'VerticalAlignment','top','HorizontalAlignment','left','FontSize',7);
    end
end
H=area(time,sample,0);
H(1).FaceColor = [188/255 208/255 255/255];
%labels = {'C5', 'C6', 'C7', 'C8', 'C9', 'C10', 'C11', 'C12', 'C14', 'C15', 'C16', 'C17', 'C18', 'C20', 'C24', 'C28', 'C32', 'C36', 'C40', 'C44'};

%text(locs,maxY*0.95*ones(length(locs),1),labels,'VerticalAlignment','top','HorizontalAlignment','left')

hold off

set(gca,'LooseInset',get(gca,'TightInset'))

set(gcf,'PaperOrientation','landscape');
print(gcf, '-fillpage', '-dpdf', strcat(sampleTitle,' - Chromatogram.pdf'));






%% Plot Boiling Point Curve
%figure(1);  clf;
%whitebg('white');
%set(gcf,'color','white');
%hfig = figure(1);
%set(hfig, 'Position', FigPos)
%ax=gca;


% plot(locs,bp,locs,bp,'x')
% xlabel('Retention Time (minutes)');
% ylabel('Boiling Point (°C)');
% title(strcat(alkaneTitle, ' n-alkanes Boiling Points'))
% text(locs,bp,labels,'VerticalAlignment','top','HorizontalAlignment','left')
% maxY=600;
% axis([0,max(time),0,maxY]);
%
% text(6.5,maxY-180,'C#','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
% text(7.2,maxY-180,'Time (min)','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
% text(8.1,maxY-180,'Boiling Point (°C)','FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center','FontWeight','bold')
%
% for i=1:length(C)
%
%     text(6.5,maxY-200-(i-1)*20,sprintf('n-C%.0f',C(i)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
%     text(7.2,maxY-200-(i-1)*20,sprintf('%.3f',locs(i)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
%     text(8.1,maxY-200-(i-1)*20,sprintf('%.0f',bp(i)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','center');
% end;
%
% set(gca,'LooseInset',get(gca,'TightInset'))
%
% set(gcf,'PaperOrientation','landscape');
% print(gcf, '-fillpage', '-dpdf', strcat('n-alkane Boiling Points',' ',' 04162022', '.pdf'));



%% Appendix X4 Correction to D86
% figure(1);   clf;
% ax = gca;
% ax.YAxis.MinorTick = 'on';
% ax.YAxis.MinorTickValues = 50:25:550;
% grid on;
% ax.YMinorGrid = 'on';
% maxY=max(bPoints*1.1);
% axis([0,100,50,maxY]);
% %axis([0,100,0,450]);
%
% boilingPoints = [
%     0.5     bPoints(points==0.5)    0
%     5       bPoints(points==5)      0
%     10      bPoints(points==10)     0
%     20      bPoints(points==20)     0
%     30      bPoints(points==30)     0
%     50      bPoints(points==50)     0
%     70      bPoints(points==70)     0
%     80      bPoints(points==80)     0
%     90      bPoints(points==90)     0
%     95      bPoints(points==95)     0
%     99.5    bPoints(points==99.5)   0
%     ];
%
% ASTMcoefs= [
%     0.5     25.351      0.32216     0.71187     -0.04221
%     5       18.822      0.06602     0.15803     0.77898
%     10      15.173      0.20149     0.30606     0.48227
%     20      13.141      0.22677     0.29042     0.46023
%     30      5.7766      0.37218     0.30313     0.31118
%     50      6.3753      0.07763     0.68984     0.18302
%     70      -2.8437     0.16366     0.42102     0.38252
%     80      -0.21536    0.25614     0.40925     0.27995
%     90      0.09966     0.24335     0.32051     0.37357
%     95      0.8988      -0.0979     1.03816     -0.00894
%     99.5    19.444      -0.38161    1.08571     0.17729
%     ];
%
% boilingPoints(1,3) = ASTMcoefs(1,2)+ASTMcoefs(1,3)*boilingPoints(1,2)+ASTMcoefs(1,4)*boilingPoints(2,2)+ASTMcoefs(1,5)*boilingPoints(3,2);
% boilingPoints(11,3) = ASTMcoefs(11,2)+ASTMcoefs(11,3)*boilingPoints(9,2)+ASTMcoefs(11,4)*boilingPoints(10,2)+ASTMcoefs(11,5)*boilingPoints(11,2);
%
% for i=2:length(ASTMcoefs)-1
%     boilingPoints(i,3) = ASTMcoefs(i,2)+ASTMcoefs(i,3)*boilingPoints(i-1,2)+ASTMcoefs(i,4)*boilingPoints(i,2)+ASTMcoefs(i,5)*boilingPoints(i+1,2);
% end;
%
% plot(points,bPoints,boilingPoints(:,1),boilingPoints(:,3),'o')
% ylabel('Temp (°C)');
% xlabel('Percent Recovered');
% legend('D2887 Distillation Curve','D86 Conversion (Appendix X4)');
% title(strcat(sampleTitle, ' Distillation Curve'))
% %set(gca,'position',[0.05 0.05 0.93 0.42],'units','normalized')
%
%
% text(10.5,maxY*0.90,'D2887','FontSize',9,'FontWeight','bold','VerticalAlignment','bottom','HorizontalAlignment','left');
% text(20.5,maxY*0.90,'D86 (Converted)','FontSize',9,'FontWeight','bold','VerticalAlignment','bottom','HorizontalAlignment','left');
%
% for i=1:length(boilingPoints)
%     s=strcat(num2str(boilingPoints(i,1)),'%');
%     if(strcmp(s,'0.5%'))
%         s='IBP';
%     end
%     if (strcmp(s,'99.5%'))
%         s='FBP';
%     end
%     text(5,maxY*0.90-0.025*maxY*(i),s,'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','left')
%     text(10.5,maxY*0.90-0.025*maxY*(i),sprintf('%.1f °C',boilingPoints(i,2)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','left');
%     text(20.5,maxY*0.90-0.025*maxY*(i),sprintf('%.1f °C',boilingPoints(i,3)),'FontSize',9,'VerticalAlignment','bottom','HorizontalAlignment','left');
% end;
%
% set(gca,'LooseInset',get(gca,'TightInset'))
%
% set(gcf,'PaperOrientation','landscape');
% print(gcf, '-fillpage', '-dpdf', strcat(sampleTitle,' - Distillation Curve.pdf'));
% %movefile(strcat(sampleTitle,' - Distillation Curve.pdf'),strcat(,sampleTitle,' - Distillation Curve.pdf'));
%
%

%% Output CSV
% CSVout ={
%     'Percent Recovered (%)', 'D2887 Results (°C)', 'D86 Conversion  (°C)';
%     boilingPoints(1,1),boilingPoints(1,2),boilingPoints(1,3);
%     boilingPoints(2,1),boilingPoints(2,2),boilingPoints(2,3);
%     boilingPoints(3,1),boilingPoints(3,2),boilingPoints(3,3);
%     boilingPoints(4,1),boilingPoints(4,2),boilingPoints(4,3);
%     boilingPoints(5,1),boilingPoints(5,2),boilingPoints(5,3);
%     boilingPoints(6,1),boilingPoints(6,2),boilingPoints(6,3);
%     boilingPoints(7,1),boilingPoints(7,2),boilingPoints(7,3);
%     boilingPoints(8,1),boilingPoints(8,2),boilingPoints(8,3);
%     boilingPoints(9,1),boilingPoints(9,2),boilingPoints(9,3);
%     boilingPoints(10,1),boilingPoints(10,2),boilingPoints(10,3);
%     boilingPoints(11,1),boilingPoints(11,2),boilingPoints(11,3);
%
%
%     '', '', '';
%     'Sample Name', getfield(sample_struct,'sample_name'), '';
%     'Sample ID', getfield(sample_struct,'sample_id'), '';
%     'Sample Source File', getfield(sample_struct,'source_file_reference'), '';
%     'Sample Injection Time (Formatted)', strrep(getfield(sample_struct,'HP_injection_time'),',',''), '';
%     'Sample Injection Time (Unformatted)', getfield(sample_struct,'injection_date_time_stamp'), '';
%     'Operator Name', getfield(sample_struct,'operator_name'), '';
%     'Method Name', getfield(sample_struct,'detection_method_name'), '';
%     'Detector Name', getfield(sample_struct,'detector_name'), '';
%     '', '', '';
%     'Blank Name', getfield(blank_struct,'sample_name'), '';
%     'Blank ID', getfield(blank_struct,'sample_id'), '';
%     'Blank Source File', getfield(blank_struct,'source_file_reference'), '';
%     'Blank Injection Time (Formatted)', strrep(getfield(blank_struct,'HP_injection_time'),',',''), '';
%     'Blank Injection Time (Unformatted)', getfield(blank_struct,'injection_date_time_stamp'), '';
%     '', '', '';
%     'Standard Name', getfield(std_struct,'sample_name'), '';
%     'Standard ID', getfield(std_struct,'sample_id'), '';
%     'Standard Source File', getfield(std_struct,'source_file_reference'), '';
%     'Standard Injection Time (Formatted)', strrep(getfield(std_struct,'HP_injection_time'),',',''), '';
%     'Standard Injection Time (Unformatted)', getfield(std_struct,'injection_date_time_stamp'), '';
%     };
%
%
%
% fid = fopen(strcat(sampleTitle,'.csv'),'w');
% for i=1:length(CSVout)
%     if i>=2&&i<=12
%         fprintf(fid,'%.1f, %.1f, %.1f\n',CSVout{i,:});
%     else
%         fprintf(fid,'%s, %s, %s\n',CSVout{i,:});
%     end
% end
%fclose(fid);
%close(figure(1))

% if (~isfile(strcat(outputDirectory,'\', 'alkanes - ',' ', alkaneTitle ,'.pdf')) || overwrite)
% movefile(strcat('n-alkanes - ',' ', alkaneTitle ,'.pdf'),strcat(outputDirectory,'\', 'alkanes - ',' ', alkaneTitle ,'.pdf'));
% else
%     delete(strcat('n-alkanes - ',' ', alkaneTitle ,'.pdf'));
% end
% if (~isfile(strcat(outputDirectory,'\',sampleTitle,'- Chromatogram.pdf')) || overwrite)
% movefile(strcat(sampleTitle,'- Chromatogram.pdf'),strcat(outputDirectory,'\',sampleTitle,'- Chromatogram.pdf'));
% else
%     delete(strcat(sampleTitle,'- Chromatogram.pdf'));
% end
% if (~isfile(strcat(outputDirectory,'\','n-alkane Boiling Points',' ',alkaneTitle, '.pdf')) || overwrite)
% movefile(strcat('n-alkane Boiling Points',' ',alkaneTitle, '.pdf'),strcat(outputDirectory,'\','n-alkane Boiling Points',' ',alkaneTitle, '.pdf'));
% else
%     delete(strcat('n-alkane Boiling Points',' ',alkaneTitle, '.pdf'));
% end
% if (~isfile(strcat(outputDirectory,'\',sampleTitle,'.csv')) || overwrite)
% movefile(strcat(sampleTitle,'.csv'),strcat(outputDirectory,'\',sampleTitle,'.csv'));
% else
%     delete(strcat(sampleTitle,'.csv'));
% end


%processed = {sampleTitle,getfield(blank_struct,'injection_date_time_stamp'),getfield(std_struct,'injection_date_time_stamp'), boilingPoints(9,3), boilingPoints(6,3)};


