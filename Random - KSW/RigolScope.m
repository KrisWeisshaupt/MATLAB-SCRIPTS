% Create VISA object
MSO1000Z = visa('ni','USB0::0x1AB1::0x4CE::DS1ZA171509418::INSTR');
% Set the device property. In this demo, the length of the input buffer is set to 2048.
MSO1000Z.InputBufferSize = 2048;
% Open the VISA object created
fopen(MSO1000Z);
% Read the waveform data
fprintf(MSO1000Z, ':wav:data?' );
% Request the data
[data,len]= fread(MSO1000Z,2048);
% Close the VISA object
fclose(MSO1000Z);
delete(MSO1000Z);
clear MSO1000Z;
% Data processing. The waveform data read contains the TMC header. The length of the header is 11
% bytes, wherein, the first 2 bytes are the TMC header denoter (#) and the width descriptor (9)
% respectively, the 9 bytes following are the length of the data which is followed by the waveform data
% and the last byte is the terminator (0x0A). Therefore, the effective waveform points read is from the
% 12nd to the next to last.
wave = data(12:len-1);
wave = wave';
subplot(211);
plot(wave);
fftSpec = fft(wave',2048);
fftRms = abs(fftSpec');
fftLg = 20*log(fftRms);
subplot(212);
plot(fftLg);