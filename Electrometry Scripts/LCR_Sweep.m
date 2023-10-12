clear all;
close all;
clc;

tic


sampleID=   'XRD1 Blotted Dry 072518';
STH=        1.886;                  % Sample Thickness
E_NUM =     1;                      %Electrode Number (1-3)

filename = strcat(sampleID,'_LCR','.png');

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
    % Find a VISA-TCPIP object.
    B2987A = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP0::10.1.10.28::hislip0::INSTR', 'Tag', '');
    
    % Create the VISA-TCPIP object if it does not exist
    % otherwise use the object that was found.
    if isempty(B2987A)
        B2987A = visa('AGILENT', 'TCPIP0::10.1.10.28::hislip0::INSTR');
    else
        fclose(B2987A);
        B2987A = B2987A(1)
    end
    
    B2987A.InputBufferSize = 1024;
    % Connect to instrument object, obj1.
    fopen(B2987A);
    
    pause(1)
    
    %Get Temperature
    s=query(B2987A,'SYST:TEMP?');
    s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
    temp=sscanf(sprintf('%s ',s{1}),'%g');
    
    %Get Humidity
    s=query(B2987A,'SYST:HUM?');
    s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
    hum=sscanf(sprintf('%s ',s{1}),'%g');

    
    USB=false;
    
    if (USB)
        
        % Find a VISA-USB object.
        E4980AL = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0957::0xD618::MY54320113::0::INSTR', 'Tag', '');
        
        % Create the VISA-USB object if it does not exist
        % otherwise use the object that was found.
        if isempty(E4980AL)
            E4980AL = visa('AGILENT', 'USB0::0x0957::0xD618::MY54320113::0::INSTR');
        else
            fclose(E4980AL);
            E4980AL = E4980AL(1)
        end
    else
        
        % Find a VISA-TCPIP object.
        E4980AL = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP0::10.1.10.29::inst0::INSTR', 'Tag', '');
        
        % Create the VISA-TCPIP object if it does not exist
        % otherwise use the object that was found.
        if isempty(E4980AL)
            E4980AL = visa('AGILENT', 'TCPIP0::10.1.10.29::inst0::INSTR');
        else
            fclose(E4980AL);
            E4980AL = E4980AL(1)
        end
    end
    
    
    E4980AL.InputBufferSize = 102400;
    set(E4980AL, 'Timeout', 120.0);
    % Connect to instrument object, obj1.
    fopen(E4980AL);
    pause(1)
    
    fprintf(E4980AL,'TRIG:SOUR BUS')
    fprintf(E4980AL,'LIST:MODE SEQ')
    fprintf(E4980AL,'INIT:CONT ON')
    fprintf(E4980AL,':TRIG:IMM')
    s=query(E4980AL,':FETC?');
    s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
    dat = cellfun(@str2double,s);
    dat=vec2mat(dat,4);
    
    freq=[20 100 500 1000 5000];
    freqFill=10046.5:5076.68:1000000;
    freq=[freq freqFill]';
    
    dat = [freq dat(:,1) dat(:,2)]
    
    
    % Main Electrodes:
    MAIN_E=[38];
    % Guard Electrodes:
    GUARD_E=[56];
    
    
    figure('Position', [100, 100, 1000, 450]);
    set(gca, 'LooseInset', get(gca,'TightInset'));
    set(gcf, 'DefaultTextFontName', 'Inconsolata');
    set(gcf, 'DefaultAxesFontName', 'Inconsolata');
    yyaxis left
    semilogx(dat(1:length(dat),1),dat(1:length(dat),2),'LineWidth', 2);
    xlabel('Frequency (Hz)');
    ylabel('\propto \epsilon''_{r}','FontSize',14,'FontWeight','bold');
    yMin=min(dat(3:length(dat),2))*0.99999;
    yMax=max(dat(3:length(dat),2))*1.00001;
    ylim([yMin yMax]);
    xlim([60 10^6]);
    yyaxis right
    semilogx(dat(1:length(dat),1),dat(1:length(dat),3).*dat(1:length(dat),2),'LineWidth', 1);
    ylabel('\propto \epsilon"_{r}','FontSize',14,'FontWeight','bold');
    
    yR=yMax-yMin;
    yyaxis left
    text(10^5,0.30*yR+yMin,sprintf('Sample ID: %s', sampleID));
    text(10^5,0.25*yR+yMin,sprintf('Sample Thickness:    %.3f mm',STH));
    text(10^5,0.20*yR+yMin,sprintf('Ambient Temperature: %.1f °C',temp));
    text(10^5,0.15*yR+yMin,sprintf('Ambient Humidity:    %.1f %%RH',hum));
    
    
    xMax=max(dat(2:length(dat),1));
    text(10^5,0.1*yR+yMin,sprintf('Main Electrode:       ø%.0fmm', MAIN_E(E_NUM)));
    text(10^5,0.05*yR+yMin,sprintf('Guard Electrode:     ø%.0fmm', GUARD_E(E_NUM)));
    
    
    hgexport(gcf,strcat(sampleID,'_LCR','.png'),hgexport('factorystyle'),'Format','png')
    set(gcf,'PaperOrientation','landscape');
    print(gcf, '-fillpage', '-dpdf', strcat(sampleID,'_LCR','.pdf'));
    %
    %
    %
    cHeader = {'Freq (Hz)' 'Cp (F)' 'D' }; % header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    %write header to file
    fid = fopen(strcat(sampleID,'_LCR','.csv'),'w');
    fprintf(fid,'%s, %s\n','SampleID:',sampleID);
    fprintf(fid,'%s, %s\n','SampleID:', datetime('now','Format','yyyy-MM-dd HH:mm:ss'));
    
    fprintf(fid,'%s, %.3f\n','Thickness (mm):', STH);
    fprintf(fid,'Main Electrode ø(mm), %.0f\n',MAIN_E(E_NUM));
    fprintf(fid,'Guard Electrode ø(mm), %.0f\n',GUARD_E(E_NUM));
    fprintf(fid,' , \n');
    fprintf(fid,'%s\n',textHeader);
    fclose(fid)
    %write data to end of file
    dlmwrite(strcat(sampleID,'_LCR','.csv'),dat,'-append');
end


toc