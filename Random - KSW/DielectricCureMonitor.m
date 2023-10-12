USB=true;
LAN1=false;

disp(sprintf('\n\n==== BK Precision 891 LCR Meter SWEEP Acquisition ====\n'));

if(USB)
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
    fprintf(LCR, 'LEV 1');
    fprintf(LCR, 'MEAS:FUNC 5');
    fprintf(LCR, 'MEAS:SPEE 1');
    fprintf(LCR, 'MEAS:RANG 1');
    fprintf(LCR, 'SWEE:FREQ:STAR 500');
    fprintf(LCR, 'SWEE:FREQ:STOP 300000');
    fprintf(LCR, 'SWEE:STEP 10');
    fprintf(LCR, 'SWEE:INTERP OFF');
    fprintf(LCR, 'SWEE:AUTO:SCAL 1');
    fprintf(LCR, 'SWEE:SWAP 1');
    fprintf(LCR, 'SWEE:STAR 1');
    pause(2);
    while(length(strtrim(query(LCR, 'SWEE:BUSY?')))==2)
        disp('WAITING FOR SWEEP...');
        pause(3);
    end
    disp('SWEEP COMPLETE.');
    
    fprintf(LCR, 'SWEE:DATA:ALL?');
    scanResults=zeros(31,3);
    for r = 1:31
        scanResults(r,:)=str2double(strsplit(fscanf(LCR),','));
    end
    
    
else if(LAN1)
        % LAN is super slow, use USB.
        LCR = instrfind('Type', 'tcpip', 'RemoteHost', '10.1.10.30', 'RemotePort', 5025, 'Tag', '');
        
        % Create the tcpip object if it does not exist
        % otherwise use the object that was found.
        if isempty(LCR)
            LCR = tcpip('10.1.10.30', 5025);
        else
            fclose(LCR);
            LCR = LCR(1)
        end
        fopen(LCR);
        
        
        
        %disp(sprintf('CSQ/0 | CSD/1 | CSR/2 | CPQ/3 | CPD/4 | CPR/5 | CPG/6\n LSQ/7 |LSD/8 | LSR/9 LPQ/10 | LPD/11 | LPR/12\n LPG/13 | ZTH/14 | YTH/15 | RX/16 | GB/17 |DCR/18\n'));
        %x = input('Choose Measurement Option:');
        
        
        fprintf(LCR, 'LEV 1');
        fprintf(LCR, 'MEAS:FUNC 3');
        fprintf(LCR, 'MEAS:SPEE 1');
        fprintf(LCR, 'MEAS:RANG 1');
        fprintf(LCR, 'SWEE:FREQ:STAR 500');
        fprintf(LCR, 'SWEE:FREQ:STOP 300000');
        fprintf(LCR, 'SWEE:STEP 0.25');
        fprintf(LCR, 'SWEE:AUTO:SCAL 1');
        fprintf(LCR, 'SWEE:STAR 1');
        pause(2);
        while(length(strtrim(query(LCR, 'SWEE:BUSY?')))==2)
            disp('WAITING FOR SWEEP...');
            pause(3);
        end
        disp('SWEEP COMPLETE.');
        
        %If using LAN the buffer size is smaller so you must query line by line
        %It is incredibly slow (~1 minute to acquire all 300 points.
        scanResults=zeros(301,3);
        for r = 1:301
            fprintf(LCR, sprintf('SWEE:POI %d', r));
            scanResults(r,1)=r;
            scanResults(r,2:3)=str2double(strsplit(query(LCR, 'SWEE:DATA?'),','));
        end
        
    else
        LCR = instrfind('Type', 'tcpip', 'RemoteHost', '10.1.10.28', 'RemotePort', 5025, 'Tag', '');
        
        % Create the tcpip object if it does not exist
        % otherwise use the object that was found.
        if isempty(LCR)
            LCR = tcpip('10.1.10.30', 5025);
        else
            fclose(LCR);
            LCR = LCR(1)
        end
        fopen(LCR)
        
        fprintf(LCR, 'LEV:AC 1');
        fprintf(LCR, 'DISP:MODE 1');
        fprintf(LCR, 'FREQ %d', 500);
        fprintf(LCR, 'MEAS:SPEE 1');
        fprintf(LCR, 'MEAS:RANG 1');
        scanResults=zeros(301,4);
        fprintf(LCR, 'MEAS:FUNC 3');
        pause(0.25);
        s=query(LCR,'MEAS:RESU?')
        s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
        scanResults(1,:)=[1 500 sscanf(sprintf('%s ',s{1}),'%g') sscanf(sprintf('%s ',s{2}),'%g')];
         for r=1:300
             disp(r)
             fprintf(LCR, sprintf('FREQ %d', r*1000));
             %fprintf(LCR, 'MEAS:FUNC 3');
             pause(0.1);
             s=query(LCR,'MEAS:RESU?');
             s=regexp(s,'-?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?','match');
             scanResults(r+1,:)=[r+1 r*1000 sscanf(sprintf('%s ',s{1}),'%g') sscanf(sprintf('%s ',s{2}),'%g')];
         end
    end
end

%fclose(LCR);
%delete(LCR);


plot(scanResults(:,2)/1000,scanResults(:,3))
xlabel('Frequency (kHz)');
ylabel('TODO');


