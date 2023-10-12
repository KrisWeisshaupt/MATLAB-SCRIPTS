clear all; close all; clc;

fs=363; %sampling frequency
window= 50; %fs/150; %width of RMS window
overlap=0.5; %RMS window overlap (as proportion of RMS window size)  RMS sampling freq = fs/(window*overlap)
load('S1.mat');
%load('ring3.mat');
font = 'Times New Roman';
set(0,'defaultTextFontName', font)
set(0,'defaultAxesFontName', font)
set(gca,'FontName',font);


%sig=Bell1(round(0.005*fs):round(1.21*fs))'; %data define
sig=S1(15,:);  %AirCool';

name='15.090-01 AirCool'; %name
L=length(sig);
distance = 0:0.00275:(L-1)*0.00275;%(0:(1/fs):(L*1/fs)-1/fs); %time same as linespace(0:L/fs:fs)

set(0, 'DefaultFigurePosition', [-1271          10        870         900])
h= suptitle(name);
set(h,'FontSize',15,'FontWeight','bold');


%Waveform
subplot(3,2,1)
plot(distance,sig,'LineWidth',0.5); xlabel('Time (s)'); ylabel('Amplitude'); title('Sound Waveform','fontweight','bold');
axis('tight');

%Spectrogram
subplot(3,2,3)
title('Spectrogram','fontweight','bold')
[s,f,t,p]=spectrogram(sig,rectwin(round(fs/30)),0,2^nextpow2(L),fs,'yaxis'); %signal, window (time resolution), window overlap,
surf(t,f/1000,10*log10(p),'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
caxis([-120, -50]);
xlabel('Time(s)'); ylabel('Frequency (kHz)'); title('Spectrogram','fontweight','bold');


%Periodogram (Spectral Power Density)
subplot(3,2,5)
[Pxx,F] = periodogram(sig,[],L,fs); %signal, window []=rectdefault hamming(L)=hamming,sampling freq
%plot(F/1000,10*log10(Pxx),'LineWidth',2)
Pxx=Pxx.^(1/4);
plot(F/1000,Pxx,'LineWidth',1.5);
set(gca,'XTick',[0:1:22]);
xlabel('Frequency (kHz)'); ylabel('Intensity^{1/4}'); title('Estimated Spectral Power Density','fontweight','bold');
axis([0 16 0 .15]);
[pks,locs] = findpeaks(Pxx,'MinPeakHeight',0.02,'MinPeakDistance',15);
text(F(locs)/1000+.1,pks+.0002,num2str((round(F(locs)))),'FontSize',8);
 
%RMS Sound Waveform
subplot(3,2,2)

rrms=rms(sig,window,window*overlap,1);
timerms=(0:(overlap*window/fs):(length(rrms)*(overlap*window/fs))-(overlap*window/fs));
[f]=fit(timerms(1:0.5*length(rrms))',(rrms(1:0.5*length(rrms)))','exp1');
fitted=f.a*exp((f.b)*timerms);
plot(timerms,rrms,timerms,fitted);
axis('tight');
xlabel('Time (s)'); ylabel('Amplitude');title('Root Mean Square Waveform','fontweight','bold');
legend('RMS',strcat(num2str(f.a),'e^{',num2str(f.b),'t}'));

%RMS Spectrogram
subplot(3,2,4)
title('Root Mean Square Spectrogram','fontweight','bold')
[s,f,t,p]=spectrogram(rrms,rectwin(round((fs/(window*overlap))/4.5)),0,2^nextpow2(L),(fs/(window*overlap)),'yaxis'); %signal, window (time resolution), window overlap,
surf(t,f,10*log10(p),'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
caxis([-120, -50]);
xlabel('Time(s)'); ylabel('Frequency'); title('RMS Spectrogram','fontweight','bold');

%Periodogram (Spectral Power Density)
subplot(3,2,6)
[Pxx,F] = periodogram(rrms,[],length(rrms),(fs/(window*overlap))); %signal, window []=rectdefault hamming(L)=hamming,sampling freq
%plot(F/1000,10*log10(Pxx),'LineWidth',2)
semilogy(F,Pxx,'LineWidth',1.5);
xlabel('Frequency (Hz)'); ylabel('Intensity (log scale)'); title('RMS Estimated Spectral Power Density','fontweight','bold');
axis('tight');
[pks,locs] = findpeaks(Pxx,'MinPeakHeight',2*10^-8);
text(F(locs),1.8*pks,num2str((round(F(locs)))),'FontSize',8);
set(gca,'XTick',[0:20:150]);
