
% Stim for psychoacosutic measurements course aud-programmet KI, HT22

fs = 44100; %Set samplerate

dt = 1/fs; %seconds per sample

%Gap range
low_r = 1;
high_r = 2;

%Gap durations to test (seconds)
gap_durs = [0.1, 0.075, 0.05, 0.025, 0.01, 0.005, 0.002, 0.001];
gap_dur_names = [100, 75, 50, 25, 10, 5, 2, 1];

%File rise/fall
rf_time_ends = 0.1;

%Gap rise/fall
rf_time = 0.002;

duration = 3;         %Noise duration (sec)
lowpassf = 18000;     %lowpassfilter frequency

for i = 1:numel(gap_durs)

    %Create and normalize noise vector
    noise = rand(1, round(duration*fs));
    noise = (noise - 0.5) * 2;

    noise = lowpass(noise, lowpassf, fs); %LP filter of noise
    noise = noise/max(abs(noise(:))); %Limit to 0 +/- 1 range by dividing signal by max(), else LP-filter may introduce clipping 

    %Create rise/fall windows for file ends
    rffreq_e = 1/(rf_time_ends * 2);                     %Frequency that has period of 2 rf_time
    t_e = (0+dt:dt:rf_time_ends);                        %vector for rise/fall
    fall_e = 0.5 * sin(2*pi*rffreq_e*t_e + pi/2) + 0.5; %fall window from 1 to 0
    rise_e = flip(fall_e);                            %rise window

    %Create rise/fall windows for gap
    rffreq = 1/(rf_time * 2);                     %Frequency that has period of 2 rf_time
    t = (0+dt:dt:rf_time);                        %vector for rise/fall
    fall = 0.5 * sin(2*pi*rffreq*t + pi/2) + 0.5; %fall window from 1 to 0
    rise = flip(fall);                            %rise window

    %Fade start and end
    noise(1:numel(rise_e)) = noise(1:numel(rise_e)).*rise_e;
    noise(end-numel(fall_e)+1:end) = noise(end-numel(fall_e)+1:end).*fall_e;

    %Create gap
    gap = [fall zeros(round(fs*gap_durs(i), 0), 1)' rise];

    %randomize gap position between 1-2 sec
    gappos = round((2*fs-1*fs).*rand(1,1) + 1*fs,0);

    %inject gap in noise
    noise(gappos:gappos+numel(gap)-1) = noise(gappos:gappos+numel(gap)-1).*gap;

    audiowrite(['noise_' num2str(gap_dur_names(i)) '.wav'], noise, fs)

end