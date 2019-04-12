%% Anderson Contreras 16-11350

clear;
clc;

% Numero de muestras
N = 2000;

% Frecuencia de Muestreo
global Fs;
Fs = 90000;

% Frecuencia de Portadora
global Fc;
Fc = 10000;

% Tiempo
global t;
t = (1:N)/Fs;

% Frecuencia de filtros
global f_bpf;
global f_lpf;
f_bpf = [8000 12000];      % Pasa Banda
f_lpf = 2000;              % Pasa Bajo


% Escala de frecuencia
F=-(Fs-Fs/N)/2:Fs/N:(Fs-Fs/N)/2;

% Selector
msg = mensaje(2);
msg_mod = modulador(msg, 'AM', Fc, 1);
msg_canal = canal(msg_mod, 'OFF', 1);
[y_BPF, y_D, y_LPF] = receptor(msg_canal, 0);

% Versi�n sin ruido de la se�al para el c�lculo de S/N
msg_canal_no_noise = canal(msg_mod, 'OFF', 1);
[y_BPF_no_noise, y_D_no_noise, y_LPF_no_noise] = receptor(msg_canal_no_noise, 0);

disp("======================================");
power_msg = round(rms(msg)^2, 3, 'decimals');
disp("Potencia del mensaje: " + power_msg);

power_msg_mod = round(rms(msg_mod)^2, 3, 'decimals');
disp("======================================");
disp("A la salida del transmisor");
disp("Potencia de la se�al: " + power_msg_mod);
disp("======================================");

power_signal_BPF = round(rms(y_BPF)^2, 3, 'decimals');
power_noise_BPF = round(rms(y_BPF - y_BPF_no_noise)^2, 3, 'decimals');
s_n_BPF = round(power_signal_BPF / power_noise_BPF, 2, 'decimals');
disp("A la salida del filtro pasabanda");
disp("Potencia de la se�al: " + power_signal_BPF);
disp("Potencia del ruido: " + power_noise_BPF);
disp("Relaci�n se�al a ruido: " + s_n_BPF + " (" + round(mag2db(s_n_BPF), 2, 'decimals') + " dB)");
disp("======================================");

power_signal_LPF = round(rms(y_LPF)^2, 3, 'decimals');
power_noise_LPF = round(rms(y_LPF - y_LPF_no_noise)^2, 3, 'decimals');
s_n_LPF = round(power_signal_LPF / power_noise_LPF, 2, 'decimals');
disp("A la salida del filtro pasabajo");
disp("Potencia de la se�al: " + power_signal_LPF);
disp("Potencia del ruido: " + power_noise_LPF);
disp("Relaci�n se�al a ruido: " + s_n_LPF + " (" + round(mag2db(s_n_LPF), 2, 'decimals') + " dB)");
return;




%% Gr�ficas del Mensaje Original %%
figure('Name','Mensaje Original');
% Graficar se�al en tiempo
subplot(2,1,1);
plot(t, msg);
axis([0 0.025 -1 1]);
plot_labels_time();

% Graficar espectro de la se�al
subplot(2,1,2);
M=abs(fftshift(fft(msg)));
M=M/N;
plot(F,M);
axis([-3000 3000 0 0.5])
grid on


%% Gr�ficas del Mensaje Modulado
figure('Name','Mensaje Modulado');
% Graficar se�al en tiempo
subplot(2,1,1);
plot(t, msg_mod);
axis([0 0.01 -1 1])
plot_labels_time();

% Graficar espectro de la se�al
subplot(2,1,2);
M=abs(fftshift(fft(msg_mod)));
M=M/N;
plot(F,M);
axis([-15000 15000 0 0.5]);
plot_labels_frecuency();


%% Gr�ficas del Canal
figure('Name','Mensaje en el Canal');
% Graficar se�al en tiempo
subplot(2,1,1);
plot(t, msg_canal);
axis([0 0.01 -1 1])
plot_labels_time();

% Graficar espectro de la se�al
subplot(2,1,2);
M=abs(fftshift(fft(msg_canal)));
M=M/N;
plot(F,M);
axis([-15000 15000 0 0.5])
plot_labels_frecuency()

%% Gr�ficas del Receptor
figure('Name','Receptor');
% Graficar se�al en tiempo
subplot(3,2,1);
plot(t, y_BPF);
plot_labels_time();
title('Se�al en el tiempo: Pasa Banda');
axis([0 0.01 -1 1])

subplot(3,2,3);
plot(t, y_D);
plot_labels_time();
title('Se�al en el tiempo: Detector');
axis([0 0.01 -1 1])

subplot(3,2,5);
plot(t, y_LPF);
plot_labels_time();
title('Se�al en el tiempo: Pasa Bajo');
axis([0 0.01 -1 1])

% Graficar espectro de la se�al
subplot(3,2,2);
M=abs(fftshift(fft(y_BPF)));
M=M/N;
plot(F,M);
plot_labels_frecuency()
title('Espectro de Frecuencia: Pasa Banda');
axis([-15000 15000 0 0.5])

subplot(3,2,4);
M=abs(fftshift(fft(y_D)));
M=M/N;
plot(F,M);
plot_labels_frecuency();
title('Espectro de Frecuencia: Detector');
axis([-15000 15000 0 0.5])

subplot(3,2,6);
M=abs(fftshift(fft(y_LPF)));
M=M/N;
plot(F,M);
plot_labels_frecuency();
title('Espectro de Frecuencia: Pasa Bajo');
axis([-15000 15000 0 0.5])


%% Funciones

% Selecci�n del mensaje
%   1: Archivo de Sonido
%   2: Tono 0,5V@100Hz
%   3: Tono 1,0V@1000Hz
%   4: Tono 0,8V@2000Hz
function msg = mensaje(selector)
    global t;
    switch selector
        case 1
            % Carga el archivo de sonido
            load('archivo1.mat');
            msg = sonido(1:200000,:);   % Ajusta el n�mero de muestras
            msg = msg - mean(msg);      % Elimina la componente DC
            msg = rescale(msg,-1,1);    % Ajusta el valor m�ximo a la unidad
        case 2
            msg = 0.5*sin(2*pi*100*t);
        case 3
            msg = sin(2*pi*1000*t);
        case 4
            msg = 0.8*sin(2*pi*2000*t);
    end
end

% Simulaci�n de modulaci�n
function msg_mod = modulador(msg, selector_modulacion, fc, u)
    global t;
    ka = 1;
    switch(selector_modulacion)
        case 'AM'
            msg_mod = ka*(1 + u*msg).*cos(2*pi*fc*t);
        case 'DSB'
            msg_mod = ka*msg.*cos(2*pi*fc*t);           
    end
end

% Simulaci�n del canal
function msg_canal = canal(msg_mod, selector_ruido, Pr)
    switch selector_ruido
        case 'ON'
            msg_canal = msg_mod + wgn(1, 200000, Pr, 'linear');
        case 'OFF'
            msg_canal = msg_mod;
    end
end

% Simulaci�n del filtro pasabanda, detector s�ncrono y filtro pasabajo
function [y_BPF, y_D, y_LPF] = receptor(msg_canal, fase_detector)
    global Fc;
    global Fs;
    global t;
    global f_bpf;
    global f_lpf;
    y_BPF = bandpass(msg_canal, f_bpf, Fs);
    y_D = y_BPF.*cos(2*pi*Fc*t+fase_detector);
    y_LPF = lowpass(y_D, f_lpf, Fs);
end

% Agrega etiquetas de gr�ficas de tiempo
function plot_labels_time()
    title('Se�al en el tiempo');
    xlabel('Tiempo (s)');
    ylabel('Msg Mod (t)');
    grid on;
end

% Agrega etiquetas en gr�ficas de frecuencia
function plot_labels_frecuency()
    title('Espectro de Frecuencia');
    xlabel('Frecuencia (Hz)');
    ylabel('Msg (F)');
    grid on;
end