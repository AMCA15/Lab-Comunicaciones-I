% Anderson Contreras
% 16-11350

% For testing different parameters in the AM and DSB-SC modulation using the
% ModulationModel Class

s = ModulationModel;

% Cambiar el número para evaluar diferentes casos
switch(2)
    % Cases with differents tones and AM modulation
    % Tono 0,5V@100Hz. AM, u = 1, fc = 10000. Power Noise = 0. Phase Receptor = 0
    case 1
        s.mensaje(2);
        s.modulador('AM', 10000, 1); % Tipo de Modulación, Frecuencia de Portadora, u
        s.canal('OFF', 0);           % Potencia del ruido
        s.f_bpf = [9900 10100];      % Set the bandpass cut-off frecuencies
        s.f_lpf = 100;               % Set the lowpass cut-off frecuency
        s.receptor(0);               % Fase del receptor
    
    % Tono 1,0V@1000Hz. AM, u = 1, fc = 10000. Power Noise = 0. Phase Receptor = 0
    case 2
        s.mensaje(3);
        s.modulador('AM', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(0);
    
    % Tono 0,8V@2000Hz. AM, u = 1, fc = 10000. Power Noise = 0. Phase Receptor = 0
    case 3
        s.mensaje(4);
        s.modulador('AM', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [8000 12000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 2000;             % Set the lowpass cut-off frecuency
        s.receptor(0);

    % Cases with differents tones and DSB-SC modulation
    % Tono 0,5V@100Hz. DSB, fc = 10000. Power Noise = 0. Phase Receptor = 0
    case 4
        s.mensaje(2);
        s.modulador('DSB', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9900 10100];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 100;              % Set the lowpass cut-off frecuency
        s.receptor(0);
    
    % Tono 1,0V@1000Hz. DSB, fc = 10000. Power Noise = 0. Phase Receptor = 0
    case 5
        s.mensaje(3);
        s.modulador('DSB', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(0);
    
    % Tono 0,8V@2000Hz. DSB, fc = 10000. Power Noise = 0. Phase Receptor = 0
    case 6
        s.mensaje(4);
        s.modulador('DSB', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [8000 12000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 2000;             % Set the lowpass cut-off frecuency
        s.receptor(0);
    
    % Cases with noise in the channel. AM
    % Tono 1,0V@1000Hz. AM, u = 1, fc = 10000. Power Noise = 0,1. Phase Receptor = 0
    case 7
        s.mensaje(3);
        s.modulador('AM', 10000, 1);
        s.canal('ON', 0.25);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(0);
        
    % Tono 1,0V@1000Hz. AM, u = 1, fc = 10000. Power Noise = 0,5. Phase Receptor = 0
    case 8
        s.mensaje(3);
        s.modulador('AM', 10000, 1);
        s.canal('ON', 0.5);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(0);
        
    % Cases with noise in the channel. DSB
    % Tono 1,0V@1000Hz. DSB, fc = 10000. Power Noise = 0,1. Phase Receptor = 0
    case 9
        s.mensaje(3);
        s.modulador('DSB', 10000, 1);
        s.canal('ON', 0.25);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(0);
        
    % Tono 1,0V@1000Hz. DSB, fc = 10000. Power Noise = 0,5. Phase Receptor = 0
    case 10
        s.mensaje(3);
        s.modulador('DSB', 10000, 1);
        s.canal('ON', 0.5);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(0);
        
    % Cases with phase in the receptor different to 0. AM
    % Tono 1,0V@1000Hz. AM, u = 1, fc = 10000. Power Noise = 0. Phase Receptor = 45
    case 11
        s.mensaje(3);
        s.modulador('AM', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(pi/4);
        
    % Tono 1,0V@1000Hz. AM, u = 1, fc = 10000. Power Noise = 0,5. Phase Receptor = 90 
    case 12
        s.mensaje(3);
        s.modulador('AM', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(pi/2);
        
    % Cases with phase in the receptor different to 0. DSB
    % Tono 1,0V@1000Hz. DSB, fc = 10000. Power Noise = 0. Phase Receptor = 45
    case 13
        s.mensaje(3);
        s.modulador('DSB', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(pi/4);
        
    % Tono 1,0V@1000Hz. DSB, fc = 10000. Power Noise = 0. Phase Receptor = 90
    case 14
        s.mensaje(3);
        s.modulador('DSB', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(pi/2);
    
    % Archivo de Sonido. AM
    case 15
        s.mensaje(1);
        s.modulador('AM',10000,1);
        s.canal('OFF', 0);
        s.f_bpf = [5000 15000];
        s.f_lpf = 5000;
        s.receptor(0);

        figure('Name', 'Mensaje Original');
        subplot(2,1,1);
        plot(s.t, s.msg);
        title('Señal en el tiempo');
        xlabel('Tiempo (s)');
        ylabel('Msg (t)');
        grid on;

        subplot(2,1,2);
        plot(s.F, abs(fftshift(fft(s.msg)))/s.N);
        title('Espectro de Frecuencia');
        xlabel('Frecuencia (Hz)');
        ylabel('Msg (F)');
        grid on;

        figure('Name', 'Mensaje Modulado');
        subplot(2,1,1);
        plot(s.t, s.msg_mod);
        title('Señal en el tiempo');
        xlabel('Tiempo (s)');
        ylabel('Msg (t)');
        grid on;

        subplot(2,1,2);
        plot(s.F, abs(fftshift(fft(s.msg_mod)))/s.N);
        title('Espectro de Frecuencia');
        xlabel('Frecuencia (Hz)');
        ylabel('Msg (F)');
        grid on;


        figure('Name', 'Mensaje Detector');
        subplot(3,2,1);
        plot(s.t, s.y_BPF);
        title('Señal en el tiempo');
        xlabel('Tiempo (s)');
        ylabel('Msg (t)');
        grid on;

        subplot(3,2,2);
        plot(s.F, abs(fftshift(fft(s.y_BPF)))/s.N);
        title('Espectro de Frecuencia');
        xlabel('Frecuencia (Hz)');
        ylabel('Msg (F)');
        grid on;

        subplot(3,2,3);
        plot(s.t, s.y_D);
        title('Señal en el tiempo: Detector');
        xlabel('Tiempo (s)');
        ylabel('Msg (t)');
        grid on;

        subplot(3,2,4);
        plot(s.F, abs(fftshift(fft(s.y_D)))/s.N);
        title('Espectro de Frecuencia: Detector');
        xlabel('Frecuencia (Hz)');
        ylabel('Msg (F)');
        grid on;

        subplot(3,2,5);
        plot(s.t, s.y_LPF);
        title('Señal en el tiempo: Pasa Bajo');
        xlabel('Tiempo (s)');
        ylabel('Msg (t)');
        grid on;

        subplot(3,2,6);
        plot(s.F, abs(fftshift(fft(s.y_LPF)))/s.N);
        title('Espectro de Frecuencia: Pasa Bajo');
        xlabel('Frecuencia (Hz)');
        ylabel('Msg (F)');
        grid on;
        
end

s.dispPower;    % Muestra las potencias de cada punto de intereres en la consola
plot(s);        % Comentar esta linea cuando se utiliza el archivo de sonido (Caso 15)