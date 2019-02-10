%% Anderson Contreras 16-11350

clear;

% Numero de muestras
N = 200000;

% Frecuencia de Muestreo
global Fs;
Fs = 90000;

% Frecuencia de Portadora
global Fc;
Fc = 10000;

% Tiempo
global t;
t = (1:N)/Fs;

% Escala de frecuencia
F=-(Fs-Fs/N)/2:Fs/N:(Fs-Fs/N)/2;

% Selector
msg = mensaje(3);
msg_mod = modulador(msg, 'AM', Fc, 1);
msg_canal = canal(msg_mod, 'OFF', 1);
[y_BPF, y_D, y_LPF] = receptor(msg_canal, 0); 

%% Gráficas del Mensaje Original %%
figure('Name','Mensaje Original');
% Graficar señal en tiempo
subplot(2,1,1);
plot(t, msg);
axis([0 0.025 -1 1]);
plot_labels_time();

% Graficar espectro de la señal
subplot(2,1,2);
M=abs(fftshift(fft(msg)));
M=M/N;
plot(F,M);
axis([-3000 3000 0 0.5])
grid on


%% Gráficas del Mensaje Modulado
figure('Name','Mensaje Modulado');
% Graficar señal en tiempo
subplot(2,1,1);
plot(t, msg_mod);
axis([0 0.01 -1 1])
plot_labels_time();

% Graficar espectro de la señal
subplot(2,1,2);
M=abs(fftshift(fft(msg_mod)));
M=M/N;
plot(F,M);
axis([-15000 15000 0 0.5]);
plot_labels_frecuency();


%% Gráficas del Canal
figure('Name','Mensaje en el Canal');
% Graficar señal en tiempo
subplot(2,1,1);
plot(t, msg_canal);
axis([0 0.01 -1 1])
plot_labels_time();

% Graficar espectro de la señal
subplot(2,1,2);
M=abs(fftshift(fft(msg_canal)));
M=M/N;
plot(F,M);
axis([-15000 15000 0 0.5])
plot_labels_frecuency()

%% Gráficas del Receptor
figure('Name','Receptor');
% Graficar señal en tiempo
subplot(3,2,1);
plot(t, y_BPF);
plot_labels_time();
title('Señal en el tiempo: Pasa Banda');
axis([0 0.01 -1 1])

subplot(3,2,3);
plot(t, y_D);
plot_labels_time();
title('Señal en el tiempo: Detector');
axis([0 0.01 -1 1])

subplot(3,2,5);
plot(t, y_LPF);
plot_labels_time();
title('Señal en el tiempo: Pasa Bajo');
axis([0 0.01 -1 1])

% Graficar espectro de la señal
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

% Selección del mensaje
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
            msg = sonido(1:200000,:);   % Ajusta el número de muestras
            msg = msg - mean(msg);      % Elimina la componente DC
            msg = rescale(msg,-1,1);    % Ajusta el valor máximo a la unidad
        case 2
            msg = 0.5*sin(2*pi*100*t);
        case 3
            msg = sin(2*pi*1000*t);
        case 4
            msg = 0.8*sin(2*pi*2000*t);
    end
end

% Simulación de modulación
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

% Simulación del canal
function msg_canal = canal(msg_mod, selector_ruido, Pr)
    switch selector_ruido
        case 'ON'
            msg_canal = msg_mod + wgn(1, 200000, Pr, 'linear');
        case 'OFF'
            msg_canal = msg_mod;
    end
end

% Simulación del filtro pasabanda, detector síncrono y filtro pasabajo
function [y_BPF, y_D, y_LPF] = receptor(msg_canal, fase_detector)
    global Fc;
    global Fs;
    global t;
    y_BPF = bandpass(msg_canal, [8000 12000], Fs);
    y_D = y_BPF.*cos(2*pi*Fc*t+fase_detector);
    y_LPF = lowpass(y_D,2000,Fs);
end

% Agrega etiquetas de gráficas de tiempo
function plot_labels_time()
    title('Señal en el tiempo');
    xlabel('Tiempo (s)');
    ylabel('Msg Mod (t)');
    grid on;
end

% Agrega etiquetas en gráficas de frecuencia
function plot_labels_frecuency()
    title('Espectro de Frecuencia');
    xlabel('Frecuencia (Hz)');
    ylabel('Msg (F)');
    grid on;
end