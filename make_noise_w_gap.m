
% Stim for psychoacosutic measurements course aud-programmet KI, HT22

fs = 44100; %Set samplerate

duration = 5;         %Noise duration (sec)
lowpassf = 18000;     %lowpassfilter frequency

%Create and normalize noise vector
noise = rand(1, round(duration*fs));
noise = (noise - 0.5) * 2;

noise = lowpass(noise, lowpassf, fs); %LP filter of noise
noise = noise/max(abs(noise(:))); %Limit to 0 +/- 1 range by dividing signal by max(), else LP-filter may introduce clipping 



%audiowrite('white_noise.wav', noise, fs);