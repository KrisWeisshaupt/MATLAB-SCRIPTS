

USB=true;
LAN1=false;

disp(sprintf('\n\n==== BK Precision 891 LCR Meter SWEEP Acquisition ====\n'));


%USB Device Connection
% Find a VISA-Serial object.
LCR = instrfind('Type', 'visa-serial', 'RsrcName', 'ASRL5::INSTR', 'Tag', '');

% Create the VISA-Serial object if it does not exist
% otherwise use the object that was found.
if isempty(LCR)
    LCR = visa('NI', 'ASRL5::INSTR');
else
    fclose(LCR);
    LCR = LCR(1)
end
fopen(LCR);
%If using USB

%disp(sprintf('CSQ/0 | CSD/1 | CSR/2 | CPQ/3 | CPD/4 | CPR/5 | CPG/6\n LSQ/7 |LSD/8 | LSR/9 LPQ/10 | LPD/11 | LPR/12\n LPG/13 | ZTH/14 | YTH/15 | RX/16 | GB/17 |DCR/18\n'));
%x = input('Choose Measurement Option:');

fprintf(LCR, '*CLS');
%fprintf(LCR, 'LEVEL 1');
fprintf(LCR, 'MEAS:FUNC 4');
fprintf(LCR, 'MEAS:SPEE 1');
fprintf(LCR, 'MEAS:RANG 1');
fprintf(LCR, 'FREQ 20');

%ScanResults = [ Time(minutes), DCR
%Cp 20Hz,   D 20Hz,     R 20Hz,
%Cp 200Hz,  D 200Hz,    R 200Hz,
%Cp 2kHz,   D 2kHz,     R 2kHz,
%Cp 20kHz,  D 20kHz,    R 20kHz,
%Cp 200kHz, D 200kHz,   R 200kHz ]

%figure
%x=[0];
%y1=[0];
%yyaxis left
%hplot=plot(x,y1);
%y2=[0];
%yyaxis right
%iplot=plot(x,y2);
%ylabel('Resistance (\Omega)')

%yyaxis left
%legend('Cp 200kHz','R 20Hz')
%xlabel('Time( minutes)')
%ylabel('Capacitance (F)')
%title('Dielectric Cure Monitoring');


scanResults=zeros(5760,16);
tic
for r = 1:5760
    %Time (seconds)
    time=toc;
    
    %DCR
    fprintf(LCR, 'MEAS:FUNC 18');
    pause(1)
    s=query(LCR,'MEAS:RESU?');
    s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
    scanResults(r,1)=time/60;
    scanResults(r,2)=sscanf(sprintf('%s ',s{1}),'%g');
    
    for f = 1:5
        
        %Set Frequency (20, 200, 2k, 20k, 200k)
        freq=2*10^f;
        fprintf(LCR, sprintf('FREQ %d', freq));
        
        % Get Cp and D
        fprintf(LCR, 'MEAS:FUNC 4');
        pause(1)
        s=query(LCR,'MEAS:RESU?');
        s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
        scanResults(r,3*f)=sscanf(sprintf('%s ',s{1}),'%g');
        scanResults(r,3*f+1)=sscanf(sprintf('%s ',s{2}),'%g');
        
        % Get R
        fprintf(LCR, 'MEAS:FUNC 5');
        pause(1)
        s=query(LCR,'MEAS:RESU?');
        s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
        scanResults(r,3*f+2)=sscanf(sprintf('%s ',s{2}),'%g');
    end
    fprintf(LCR, '*CLS');
    %x=scanResults(1:r,1);
    %y1=scanResults(1:r,15);
    %hplot.XDataSource = 'x';
    %hplot.YDataSource = 'y1';
    %y2=scanResults(1:r,5);
   % iplot.XDataSource = 'x';
  %  iplot.YDataSource = 'y2';
 %   refreshdata
    pause(30-(toc-time));
    if(mod(r,20)==0)
        csvwrite('scan.csv',scanResults)
    end
end

fprintf(LCR, '*CLS');
%fclose(LCR);
%delete(LCR);



