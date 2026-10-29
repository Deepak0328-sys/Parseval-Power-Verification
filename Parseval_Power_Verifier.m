clc;
clear;
close;
Fs = input("Enter sampling frequency (100-20000Hz):-");
if isempty(Fs)
    Fs = 1000;
end
if Fs < 100 || Fs > 20000
    disp("Invalid sampling frequency! Enter a value between 100 and 20000 Hz.");
    return;
end
N = input("Enter Number Of Samples(50-10000):-");
if isempty(N)
    N = 500;
end
if N < 50 || N > 10000 || N ~= fix(N)
    disp("Invalid input! Enter an integer between 50 and 10000.");
    return;
end
A = input("Enter Amplitude(0-100 V):-");
if isempty(A)
    A = 2;
end
if A <= 0 || A > 100
    disp("Invalid amplitude! Enter a value greater than 0 and up to 100 V.");
    return;
end
f = input("Enter  Signal Frequency(1-20Hz):-");
if isempty(f)
    f = 10;
end
if f < 1 || f > 20
    disp("Invalid frequency! Enter a value between 1 and 20 Hz.");
    return;
end
n = 0:N-1;
t= n/Fs;
signals = input("Enter the Choice(1.Pure Sine,2.Pure Cosine,3.PureSquareWave,4.Noisy Signal):-");

if isempty(signals)
    signals = 1;
end
switch signals
    case 1 %pure sine
        x= A*sin(2*pi*f*t);
    case 2 %pure cosine
        x= A*cos(2*pi*f*t);
    case 3 %square wave
        x= A*sign(sin(2*pi*f*t));
    case 4 %Noisy Signal
        noise_level = input("Enter noise level(0-5V):-");
        if isempty(noise_level)
            noise_level = 0.5;
        end
        if noise_level < 0 || noise_level > 5
            disp("Invalid noise level! Enter a value between 0 and 5 V.");
            return;
        end
        w = input("Choose The Base Waveform(1.Pure Sine,2.Pure Cosine,3.PureSquareWave):-");
        switch w
            case 1 
                %generate pure sine wave
                 x = A*sin(2*pi*f*t)+noise_level*randn(1,N);
            case 2 
                %generate pure cosine wave
                x= A*cos(2*pi*f*t)+noise_level*randn(1,N);
            case 3
                %generate pure square wave
                x= A*sign(sin(2*pi*f*t))+noise_level*randn(1,N);
            otherwise
                disp("Invalid Base Baseform Selected");
                return;
        end
        
    otherwise
        disp("Error,Invalid Signal Selected");
        return;
end
P_time = sum(abs(x).^2)/N;
X = fft(x);
P_freq= sum(abs(X).^2)/(N^2);
err = abs(P_time-P_freq);
fprintf("------------------------\n");
fprintf("Time Domain Average Power(P_time): %.4f W\n",P_time);
fprintf("Frequency Domain Average Power(P_freq): %.4f W\n",P_freq);
fprintf("Absolute Verification Error(err): %.2e\n",err);
fprintf("------------------------\n");
figure();
plot(t,x);
title('Input Signal In Time Domain');
xlabel('Time(s)');
ylabel('Amplitude(V)');
grid on;
f_axis = (0:N-1)*(Fs/N);
figure();
plot(f_axis,abs(X)/N);
title('Input Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 50]);
grid on;
figure();
bar([1,2],[P_time,P_freq]);
set(gca,'XTick',[1,2]);
set(gca,'XTickLabel',{"Time Domain","Frequency Domain"});
ylabel("Average Power");
title("Parseval Power Verification");
grid on;