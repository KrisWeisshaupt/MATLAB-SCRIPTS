clear all;
close all;
clc;

tic

sampleID=       'MAP 10C 85A TPU R2'    %'DP420 BK Sp.5 100%RH  5min Recovery
STH=            0.212;          % Sample Thickness mm 0.1467
E_NUM =         1;              % Electrode Number (1-3)
VOLTAGE =       0.5;            %

    % Main Electrodes: ø50mm, ø26mm, ø76
    MAIN_E=[50 26 76];
    
    % Guard Electrodes: ø70mm, ø38mm, ø88mm
    GUARD_E=[70 38 88];


filename = strcat(sampleID,'_VRES','.png');



overwriteFile = true; % Default to overwriting or creating new file.

if exist(filename, 'file')
    % Ask user if they want to overwrite the file.
    promptMessage = sprintf('This file already exists:\n%s\nDo you want to overwrite it?', filename);
    titleBarCaption = 'Overwrite?';
    buttonText = questdlg(promptMessage, titleBarCaption, 'Yes', 'No', 'Yes');
    if strcmpi(buttonText, 'No')
        % User does not want to overwrite.
        % Set flag to not do the write.
        overwriteFile = false;
    end
end

if overwriteFile
    
    USB=false;
  
    
    if (USB)
        
        % Find a VISA-USB object.
        B2987A = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0957::0xD618::MY54320113::0::INSTR', 'Tag', '');
        
        % Create the VISA-USB object if it does not exist
        % otherwise use the object that was found.
        if isempty(B2987A)
            B2987A = visa('AGILENT', 'USB0::0x0957::0xD618::MY54320113::0::INSTR');
        else
            fclose(B2987A);
            B2987A = B2987A(1)
        end
    else
        
        % Find a VISA-TCPIP object.
        B2987A = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP0::192.168.0.27::inst0::INSTR', 'Tag', '');
        
        % Create the VISA-TCPIP object if it does not exist
        % otherwise use the object that was found.
        if isempty(B2987A)
            B2987A = visa('AGILENT', 'TCPIP0::192.168.0.27::inst0::INSTR');
        else
            fclose(B2987A);
            B2987A = B2987A(1)
        end
    end
    
    
    B2987A.InputBufferSize = 102400;
    % Connect to instrument object, obj1.
    fopen(B2987A);
    
    
    %Setup
    fprintf(B2987A, '*CLS');
    fprintf(B2987A,'DISP:ENAB ON');
    %fprintf(B2987A,'SENS:FUNC "CURR"');
    %fprintf(B2987A,'SENS:FUNC "RES"');
    c=fix(clock);
    fprintf(B2987A, sprintf('SYST:DATE %d,%d,%d', c(1), c(2), c(3)));
    fprintf(B2987A, sprintf('SYST:TIME %d,%d,%d', c(4), c(5), c(6)));
    
    fprintf(B2987A, 'SYST:TEMP:SEL HSEN');
    fprintf(B2987A, 'SYST:TEMP:UNIT C');
    
    %Effective Perimeter
    EPER=pi*(MAIN_E(E_NUM) + GUARD_E(E_NUM))/2;
    fprintf(B2987A,'CALC:MATH:VAR:NAME "EPER"');
    fprintf(B2987A,'CALC:MATH:VAR:DEF %d', EPER);
    
    %Gap Length
    GLEN=(GUARD_E(E_NUM) - MAIN_E(E_NUM))/2;
    fprintf(B2987A,'CALC:MATH:VAR:NAME "GLEN"');
    fprintf(B2987A,'CALC:MATH:VAR:DEF %d', GLEN);
    
    %Effective Area
    B=1-4/pi*STH/GLEN*log(cosh(pi/4*GLEN/STH));
    EAR=pi*(MAIN_E(E_NUM)+GLEN*B)^2/4;
    fprintf(B2987A,'CALC:MATH:VAR:NAME "EAR"');
    fprintf(B2987A,'CALC:MATH:VAR:DEF %d', EAR);
    
    
    %Sample Thickness (mm)
    fprintf(B2987A,'CALC:MATH:VAR:NAME "STH"');
    fprintf(B2987A,'CALC:MATH:VAR:DEF %d', STH);  %Thickness in mm
    
    %Trigger
    % fprintf(B2987A,'TRIG:ACQ:COUNT 3');
    % fprintf(B2987A,'TRIG:ACQ:DEL 500');
    % fprintf(B2987A,'TRIG:ACQ:TIM 5');
    % fprintf(B2987A,'TRIG:TRAN:TIM 0.0001');
    
    %Sweep
    % fprintf(B2987A,'SOUR:SWE:SPAC LIN');
    % fprintf(B2987A,'SOUR:SWE:POIN 1');
    % fprintf(B2987A,'SOUR:SWE:STA SING');   %Single Sweep (low to high)
    % fprintf(B2987A,'SOUR:VOLT:STAR 500');  %Low 500
    % fprintf(B2987A,'SOUR:VOLT:STOP 500');  %High 500
    % fprintf(B2987A,'SOUR:VOLT:RANG 1000');
    
    
    % fprintf(B2987A,'SOUR:VOLT 500');
    
    
    % fprintf(B2987A,'OUTP 1');
    % fprintf(B2987A,'INP 1');
    
    
    %Get Temperature
    s=query(B2987A,'SYST:TEMP?');
    s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
    temp=sscanf(sprintf('%s ',s{1}),'%g');
    
    %Get Humidity
    s=query(B2987A,'SYST:HUM?');
    s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
    hum=sscanf(sprintf('%s ',s{1}),'%g');
    
    
    
    %fprintf(B2987A,'INIT:ACQ');
    
    period=5;
    count=27;
    
    
    s=query(B2987A,'CALC:MATH:DATA?');
    s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
    volRes = cellfun(@str2double,s)';
    time=0:period:period*(count-1);
    time=time';
    
    fprintf(B2987A,'FORM:ELEM:SENS VOLT,CURR,RES,TEMP,HUM');
    s=query(B2987A,'FETC:ARR? (@1)');
    s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
    dat = cellfun(@str2double,s);
    dat=vec2mat(dat,5);
    %dat(:,1) = VOLTAGE;  %Test Voltage
    volRes=dat(:,3).*((EAR*10^-2)/(STH*10^-1));
    dat=[time dat volRes];
    
    
    %set(gca, 'LooseInset', get(gca,'TightInset'))
        figX = 1000;
    figY = 450;
    figure('Position', [100, 100, figX, figY]);

    set(gca, 'LooseInset', get(gca,'TightInset'));
    set(gcf, 'DefaultTextFontName', 'Inconsolata');
    set(gcf, 'DefaultAxesFontName', 'Inconsolata');
    plot(time,volRes,'LineWidth', 2);
    xlabel('Time (seconds)');
    ylabel('Volume Resistivity (\Omegacm)');
    yMin=0.8*min(volRes);
    yMax=1.2*max(volRes);
    ylim([yMin yMax]);
    xMin=0;
    xMax=period*(count-1);
    xlim([xMin xMax]);
    ax = gca;
    set(ax,'XTick',xMin:15:xMax);
    line([60,60],[0,volRes(time==60)],'Color','black','LineStyle',':','LineWidth',1);
    line([0,60],[volRes(time==60),volRes(time==60)],'Color','black','LineStyle',':','LineWidth',1);
    
    % For checking if current varies by more than 5% in the last 75% of the
    % sampling duration (15-60 seconds for a standard test)
    types={'(apparent)', '(steady-state)'};
    
    yR=yMax-yMin;
    text(period,0.95*yR+yMin,sprintf('Sample ID:           %s', sampleID));
    text(period,0.90*yR+yMin,sprintf('Volume Resistivity:  %0.3e \\Omegacm  %s',volRes(time==60),types{1+(min(dat(find(time>15,1,'first'):find(time>=60,1,'first'),3))/max(dat(find(time>15,1,'first'):find(time>=60,1,'first'),3))>=0.95)}));
    text(period,0.85*yR+yMin,sprintf('Thickness (l):    %.3f mm',STH));
    text(period,0.80*yR+yMin,sprintf('Ambient Temperature: %.1f °C',temp));
    text(period,0.75*yR+yMin,sprintf('Ambient Humidity:    %.1f %%RH',hum));
    text(period,0.70*yR+yMin,sprintf('Minimum Resistivity: %0.3e \\Omegacm at time=%.0f',min(volRes),time(find(volRes==min(volRes),1, 'first'))));
    text(2*period,0.60*yR+yMin,'$$ \rho_v = R_v \frac{A}{l} $$', 'Interpreter', 'latex')
    
%     text(0.8*xMax,0.225*yR+yMin,sprintf('Test Volage:  %.0fV', VOLTAGE));
%     text(0.8*xMax,0.175*yR+yMin,sprintf('Main Electrode:  ø%.0fmm', MAIN_E(E_NUM)));
%     text(0.8*xMax,0.125*yR+yMin,sprintf('Guard Electrode: ø%.0fmm', GUARD_E(E_NUM)));
%     text(0.8*xMax,0.075*yR+yMin,sprintf('Effective Area:  %.3fcm^2', EAR/100));
    
       text(0.75*xMax,0.275*yR+yMin,sprintf('Test Voltage:    %.1fV', VOLTAGE));
    text(0.75*xMax,0.225*yR+yMin,sprintf('Main Electrode:  ø%.0fmm', MAIN_E(E_NUM)),'Color','blue');
    text(0.75*xMax,0.175*yR+yMin,sprintf('Guard Electrode: ø%.0fmm', GUARD_E(E_NUM)), 'Color', 'red');
    text(0.75*xMax,0.125*yR+yMin,sprintf('Effective Area:  %.3fcm^2', EAR/100), 'Color', [0 0.5 0]);
    text(0.75*xMax,0.075*yR+yMin,sprintf('Gap Length (g):  %.0fmm', GLEN));
         EAR=pi*(MAIN_E(E_NUM)+GLEN*B)^2/4;
     effectiveDiameter=sqrt(EAR/pi)*2;
       
    
     annotation('ellipse',[0.64 0.13 0.1 0.1*figX/figY],'Color','red');
    
     %eRat=(MAIN_E(E_NUM)+GUARD_E(E_NUM))/2/GUARD_E(E_NUM);
      eRat=effectiveDiameter/GUARD_E(E_NUM);
     annotation('ellipse',[0.64+0.5*(0.1-eRat*0.1) 0.13+0.5*(0.1*figX/figY-eRat*0.1*figX/figY) 0.1*eRat 0.1*figX/figY*eRat], 'LineStyle','--', 'Color', 'none','FaceColor',[0.75 1 0.75]);
   
     eRat=MAIN_E(E_NUM)/GUARD_E(E_NUM);
     annotation('ellipse',[0.64+0.5*(0.1-eRat*0.1) 0.13+0.5*(0.1*figX/figY-eRat*0.1*figX/figY) 0.1*eRat 0.1*figX/figY*eRat],'Color','blue');
    
    
    
%     eRat=MAIN_E(E_NUM)/GUARD_E(E_NUM);
%     
%      annotation('ellipse',[0.64 0.13 0.1 0.1*figX/figY],'Color','red');
%      annotation('ellipse',[0.64+0.5*(0.1-eRat*0.1) 0.13+0.5*(0.1*figX/figY-eRat*0.1*figX/figY) 0.1*eRat 0.1*figX/figY*eRat],'Color','blue');
%      eRat=(MAIN_E(E_NUM)+GUARD_E(E_NUM))/2/GUARD_E(E_NUM);
%      annotation('ellipse',[0.64+0.5*(0.1-eRat*0.1) 0.13+0.5*(0.1*figX/figY-eRat*0.1*figX/figY) 0.1*eRat 0.1*figX/figY*eRat], 'LineStyle','--', 'Color', [0 0.5 0]);
    
    
    hgexport(gcf,strcat(sampleID,'_VRES','.png'),hgexport('factorystyle'),'Format','png')
    set(gcf,'PaperUnits','centimeters','PaperSize',[35 15])
fig = gcf;fig.PaperUnits = 'centimeters'; 
fig.PaperPosition = [0 0 35 15];fig.Units = 'centimeters';
fig.PaperSize=[35 15];fig.Units = 'centimeters';
%print(fig,'fig_name','-dpdf','-r200')
    print(gcf, '-fillpage', '-dpdf','-r200', strcat(sampleID,'_VRES','.pdf'));
    
    
    
    %fprintf(B2987A,'OUTP 0');
    %fprintf(B2987A,'INP 0');
    %     'Sample ID:' sampleID '' '' '' '' '';
    %     'Sample Thickness:' STH '' '' '' '' '';
    %     'Main Electrode:' MAIN_E(E_NUM) 'Guard Electrode:' GUARD_E(E_NUM) '' '' '';
    %     'Volume Resistivity' volRes(13) types{1+(min(dat(5:13,3))/max(dat(5:13,3))>=0.95)} '' '' '' '';
    cHeader = {'Time (s)' 'Voltage (V)' 'Current (A)' 'Resistance (Ohms)' 'Temp (C)' 'Humidity' 'VolResistivity (Ohmsxcm)' }; % header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    %write header to file
    fid = fopen(strcat(sampleID,'_VRES','.csv'),'w');
    fprintf(fid,'%s, %s\n','SampleID:',sampleID);
    fprintf(fid,'%s, %s\n','SampleID:', datetime('now','Format','yyyy-MM-dd HH:mm:ss'));
    
    fprintf(fid,'%s, %.3f\n','Thickness (mm):', STH);
    fprintf(fid,'Volume Resistivity (Ohmsxcm):, %0.3e, %s\n',volRes(13),types{1+(min(dat(5:13,3))/max(dat(5:13,3))>=0.95)})
    fprintf(fid,'Main Electrode ø(mm), %.0f\n',MAIN_E(E_NUM));
    fprintf(fid,'Guard Electrode ø(mm), %.0f\n',GUARD_E(E_NUM));
    fprintf(fid,' , \n');
    fprintf(fid,'%s\n',textHeader);
    

    fclose(fid)
    %write data to end of file
    dlmwrite(strcat(sampleID,'_VRES','.csv'),dat,'-append');
end
toc