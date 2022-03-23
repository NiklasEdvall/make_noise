
fs = 44100; %Set samplerate

duration = 5*60;    %Noise duration (sec)
lowpassf = 18000;        %lowpassfilter frequency

dt = 1/fs;          % length of sample

%Create and normalize noise vector
noise = rand(1, round(duration*fs));
noise = (noise - 0.5) * 2;

noise = lowpass(noise, lowpassf, fs); %LP filter of noise
noise = noise/max(abs(noise(:))); %Limit to 0 +/- 1 range by dividing signal by max(), else LP-filter may introduce clipping 

audiowrite('white_noise.wav', noise, fs);

%frequency spectrum
% pspectrum(noise, fs);
% set(gca, 'XScale', 'log');
% xlim([0.1 20]);
% set(gca, 'XTickLabel', [100 1000 10000]);

