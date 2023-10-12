clear all;
close all;
clc;

tic

sampleID=       '102181-1-1 MCI MPI Cable 1000V';
D1=             0.291         ;% Sample ID (Inches)
D2=             0.3784         ;% Sample OD (Inches)
g=              1.5              ;% Gap(mm)
L=              130             ;% Electrode1 Length

E_NUM =         1;              % Electrode Number (1-3)

D1=             D1*25.4;        % Conversion to mm
D2=             D2*25.4;        % Conversion to mm
STH=            D2-D1;          % Sample Thickness mm

filename = strcat(sampleID,'_RES','.png');

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
        B2987A = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP0::192.168.0.27::hislip0::INSTR', 'Tag', '');
        
        % Create the VISA-TCPIP object if it does not exist
        % otherwise use the object that was found.
        if isempty(B2987A)
            B2987A = visa('AGILENT', 'TCPIP0::192.168.0.27::hislip0::INSTR');
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
    
    %fprintf(B2987A, 'CALC:MATH:VAR:DEL:ALL');
    
    
    %fprintf(B2987A,'*RCL 5');
    
    
    
    
    
    
    
    
    
    
    
    % Main Electrodes: ø50mm, ø26mm, ø76
    MAIN_E=[90];
    
    % Guard Electrodes: ø70mm, ø38mm, ø88mm
    GUARD_E=[10];
    
    %Effective Perimeter
    EPER=2*pi*D2;
    fprintf(B2987A,'CALC:MATH:VAR:NAME "EPER"');
    fprintf(B2987A,'CALC:MATH:VAR:DEF %d', EPER);
    
    %Gap Length
    GLEN=g;
    fprintf(B2987A,'CALC:MATH:VAR:NAME "GLEN"');
    fprintf(B2987A,'CALC:MATH:VAR:DEF %d', GLEN);
    
    %Effective Area
    B=1-4/pi*STH/g*log(cosh(pi/4*g/STH));
    EAR=pi*(D2+D1)/2*(L+GLEN*B);
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
    count=25;
    
    
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
    dat(:,1)=500.0;
    volRes=dat(:,3).*((EAR*10^-2)/(STH*10^-1));
    dat=[time dat volRes];
    
    
    %set(gca, 'LooseInset', get(gca,'TightInset'))
    
    figure('Position', [100, 100, 1000, 450]);
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
    text(period,0.85*yR+yMin,sprintf('Sample Geometry:    ID %0.3fmm (%0.4f"), OD %.3fmm (%.4f"), Thickness %.3fmm (%.4f")', D1, D1/25.4, D2, D2/25.4, STH, STH/25.4));
    text(period,0.80*yR+yMin,sprintf('Ambient Temperature: %.1f°C',temp));
    text(period,0.75*yR+yMin,sprintf('Ambient Humidity:    %.1f%%RH',hum));
    text(period,0.70*yR+yMin,sprintf('Minimum Resistivity: %0.3e \\Omegacm at time=%.0f',min(volRes),time(find(volRes==min(volRes),1, 'first'))));
    text(2*period,0.60*yR+yMin,'$$ \rho = R \frac{A}{t} $$', 'Interpreter', 'latex')
    
    
    text(2*period,0.60*yR+yMin,'$$ \rho = R \frac{A}{t} $$', 'Interpreter', 'latex')
    text(0.75*xMax,0.175*yR+yMin,sprintf('Main Electrode Length:  %.0fmm', MAIN_E(E_NUM)));
    text(0.75*xMax,0.125*yR+yMin,sprintf('Guard Electrode Gap:    %.0fmm', GLEN));
    text(0.75*xMax,0.075*yR+yMin,sprintf('Effective Area:         %.3fcm^2', EAR/100));
    
    hgexport(gcf,strcat(sampleID,'_RES','.png'),hgexport('factorystyle'),'Format','png')
    set(gcf,'PaperOrientation','landscape');
    print(gcf, '-fillpage', '-dpdf', strcat(sampleID,'_RES','.pdf'));
    
    
    
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
    fid = fopen(strcat(sampleID,'_RES','.csv'),'w');
    fprintf(fid,'%s, %s\n','SampleID:',sampleID);
    fprintf(fid,'%s, %s\n','SampleID:', datetime('now','Format','yyyy-MM-dd HH:mm:ss'));
    fprintf(fid,'Inner Diameter (mm), %.3f\n',D1);
    fprintf(fid,'Outer Diameter (mm), %.3f\n',D2);
    fprintf(fid,'%s, %.3f\n','Thickness (mm):', STH);
    fprintf(fid,'Volume Resistivity (Ohmsxcm):, %0.3e, %s\n',volRes(13),types{1+(min(dat(find(time>15,1,'first'):find(time>=60,1,'first'),3))/max(dat(find(time>15,1,'first'):find(time>=60,1,'first'),3))>=0.95)})
    fprintf(fid,'Main Electrode Length(mm), %.0f\n',MAIN_E(E_NUM));
    fprintf(fid,'Guard Electrode  Gap(mm), %.0f\n',GLEN);
    fprintf(fid,' , \n');
    fprintf(fid,'%s\n',textHeader);
    fclose(fid)
    %write data to end of file
    dlmwrite(strcat(sampleID,'_RES','.csv'),dat,'-append');
end
toc