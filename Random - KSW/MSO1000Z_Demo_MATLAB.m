% Create VISA object
MSO1000Z = visa('ni','USB0::0x1AB1::0x04CE::DS1ZA171509418::INSTR');
% Set the device property. In this demo, the length of the input buffer is set to 2048.
MSO1000Z.InputBufferSize = 250000;
% Open the VISA object created
fopen(MSO1000Z);
% Read the waveform data
fprintf(MSO1000Z, ':STOP');

memDepth=12000000;

fprintf(MSO1000Z, ':CHANnel1:DISPlay ON')
fprintf(MSO1000Z, ':CHANnel2:DISPlay ON')
fprintf(MSO1000Z, 'ACQuire:MDEPth %d', memDepth)

fprintf(MSO1000Z, ':WAVeform:SOURce CHANne11');
fprintf(MSO1000Z, ':WAVeform:MODE RAW');
fprintf(MSO1000Z, ':WAVeform:FORMat BYTE')

wave=0;

for i=0:memDepth/250000-1
i
fprintf(MSO1000Z, ':WAV:STAR %d', i*250000+1)
fprintf(MSO1000Z, ':WAV:STOP %d', (i+1)*250000);
fprintf(MSO1000Z, ':WAVeform:DATA?');
% Request the data
data = fread(MSO1000Z,250000);
wave = [wave;data(12:len-1)];

end;
% fprintf(MSO1000Z, ':WAV:STAR 250001')
% fprintf(MSO1000Z, ':WAV:STOP 500000');
% fprintf(MSO1000Z, ':WAVeform:DATA?');
% % Request the data
% data=fread(MSO1000Z,250000);
% data=data(12:len-1);
% wave = [wave;data]; 
% Close the VISA object
fclose(MSO1000Z);
delete(MSO1000Z);
clear MSO1000Z;
% Data processing. The waveform data read contains the TMC header. The
% length of the header is 11 bytes, wherein, the first 2 bytes are the TMC
% header denoter (#) and the width descriptor (9) respectively, the 9 bytes
% following are the length of the data which is followed by the waveform
% data and the last byte is the terminator (0x0A). Therefore, the effective
% waveform points read is from the 12nd to the next to last.
%wave = data(12:len-1);

wave = wave';
subplot(211);
plot(wave);
fftSpec = fft(wave',20000);
fftRms = abs(fftSpec');
fftLg = 20*log(fftRms);
subplot(212);
plot(fftLg);