% Anderson Contreras
% 16-11350

% Class to model FM

classdef ModulationModel < handle
    properties
       % General Parameter
       N
       Fs

       % Signals
       msg
       msg_mod
       msg_canal
       y_A
       y_B
       y_C
       y_D
       y_E

       % Modulation
       Fc
       FreqDev

       % Channel
       NoisePower

       % Detector
       Flo
       FreqDev_D
       F_IF
       f_bpf
       f_lpf
    end
    properties (Dependent, SetAccess = private, Hidden)
       t           % Escala de tiempo
       F           % Escala de frecuencia
    end

    methods
        function obj = ModulationModel
           obj.N = 825000;
           obj.Fs = 110250;
           obj.Fc = 10000;    
           obj.F_IF = 14000;
           obj.f_bpf = [8500 19500];   % Pasa Banda
           obj.f_lpf = 5500;            % Pasa Bajo
        end

        function t = get.t(obj)
            t = (1:obj.N)/obj.Fs;
        end
        function F = get.F(obj)
            F = -(obj.Fs-obj.Fs/obj.N)/2:obj.Fs/obj.N:(obj.Fs-obj.Fs/obj.N)/2;
        end

        function obj = mensaje(obj, selector)
        % Seleccion del mensaje
        %   1: Sonido
        %   1: Señal Compuesta
        %   3: Tono 1,0V@1000Hz
            switch selector
                case 1
                    obj.msg = sin(2*pi*1000*obj.t);
                
                case 2
                    obj.msg = sin(2*pi*1000/2*obj.t);
                    
                case 3
                    obj.msg = sin(2*pi*1000/5*obj.t);
                
                case 4
                    % Carga el archivo de sonido
                    data = load('arch1.mat');
                    obj.msg = data.msg1;                 % Ajusta el numero de muestras
                
                case 5
                    % Carga el archivo de la señal compuesta
                    data = load('arch2.mat');
                    obj.msg = data.y_rf_tot;             % Ajusta el numero de muestras
            end
        end

        % Simulacion de modulacion
        function obj = modulador(obj, fc, freqdev)
            switch nargin
                case 1                      % Si no se pasan argumentos no se realiza la modulación
                    obj.msg_mod = obj.msg;
                otherwise
                    obj.Fc = fc;
                    obj.FreqDev = freqdev;
                    obj.msg_mod = fmmod(obj.msg, fc, obj.Fs, obj.FreqDev);                    
            end
        end

        % Simulacion del canal
        function obj = canal(obj, Pr)
            switch nargin
                case 1                      % Si no se pasan argumentos no se agrega ruido a la señal
                    obj.msg_canal = obj.msg_mod;
                    obj.NoisePower = 0;
                otherwise
                    obj.NoisePower = Pr;
                    obj.msg_canal = obj.msg_mod + wgn(1, obj.N, Pr, 'linear');
            end
        end

        % Simulacion del filtro pasabanda, detector sincrono y filtro pasabajo
        function obj = receptor(obj, flo, freqdev)
            obj.Flo = flo;
            obj.FreqDev_D = freqdev;
            
            obj.y_A = obj.msg_canal;
            obj.y_B = obj.y_A.*cos(2*pi*obj.Flo*obj.t);
            obj.y_C = bandpass(obj.y_B, obj.f_bpf, obj.Fs);
            obj.y_D = fmdemod(obj.y_C, obj.F_IF, obj.Fs, obj.FreqDev_D);
            obj.y_E = lowpass(obj.y_D, obj.f_lpf, obj.Fs);
        end
        
        function play(obj)
            playblocking(audioplayer(obj.y_E(50:end-5), obj.Fs));
        end

        function dispPower(obj)
            % Power of the message received
            power_sr = obj.PowerRMS(obj.msg_mod);
            
            % Power of the noise received
            noise = wgn(1, obj.N, obj.NoisePower, 'linear');
            power_nr = obj.PowerRMS(noise);

            
            % Power of the message detected
            SA = obj.msg_mod;
            SB = SA.*cos(2*pi*obj.Flo*obj.t);
            SC = bandpass(SB, obj.f_bpf, obj.Fs);
            SD = fmdemod(SC, obj.F_IF, obj.Fs, obj.FreqDev_D);
            SE = lowpass(SD, obj.f_lpf, obj.Fs);
            power_sd = obj.PowerRMS(SE);
            
            % Power of the noise detected
            NA = wgn(1, obj.N, obj.NoisePower, 'linear');
            NB = NA.*cos(2*pi*obj.Flo*obj.t);
            NC = bandpass(NB, obj.f_bpf, obj.Fs);
            ND = fmdemod(NC, obj.F_IF, obj.Fs, obj.FreqDev_D);
            NE = lowpass(ND, obj.f_lpf, obj.Fs);
            power_nd = obj.PowerRMS(NE);
            
            %obj.PrintPwrMsgs(power_msg, power_msg_mod);
            obj.PrintPwrSignalNoise("Señal recibida", power_sr, power_nr);
            obj.PrintPwrSignalNoise("Señal detectada", power_sd, power_nd);
        end

        % Plot modulated signal
        function fftplot(obj)
            fftplot(obj.msg_mod, obj.Fs);
            obj.plot_labels_frecuency(" Señal Modulada");
        end      
        
        function plot_receptor(obj)
            fftplot(obj.y_A, obj.Fs);
            obj.plot_labels_frecuency(". y_A");
            fftplot(obj.y_B, obj.Fs);
            obj.plot_labels_frecuency(". y_B");
            fftplot(obj.y_C, obj.Fs);
            obj.plot_labels_frecuency(". y_C");
            fftplot(obj.y_D, obj.Fs);
            obj.plot_labels_frecuency(". y_D");
            fftplot(obj.y_E, obj.Fs);
            obj.plot_labels_frecuency(". y_E");
        end
        
    end

    methods (Static)        
        function power = PowerRMS(Signal)
           power = rms(Signal)^2;
        end
        
        function PrintPwrMsgs(power_msg, power_msg_mod)
            disp("======================================");
            disp("Potencia del mensaje: " + power_msg);
            disp("======================================");
            disp("A la salida del transmisor");
            disp("Potencia de la señal: " + power_msg_mod);
        end
        
        function PrintPwrSignalNoise(title, power_signal, power_noise)
            sn = power_signal / power_noise;
            disp("======================================");
            disp(title);
            disp("Potencia de la señal: " + power_signal);
            disp("Potencia del ruido: " + power_noise);
            disp("Relacion señal a ruido: " + sn + " (" + round(mag2db(sn), 2, 'decimals') + " dB)");
        end
        
        % Agrega etiquetas de graficas de tiempo
        function plot_labels_time(SignalsName)
            title('Señal en el tiempo' + SignalsName);
            xlabel('Tiempo (s)');
            ylabel('Msg (t)');
            grid on;
        end

        % Agrega etiquetas en graficas de frecuencia
        function plot_labels_frecuency(SignalsName)
            title('Espectro de Frecuencia' + SignalsName);
            xlabel('Frecuencia (Hz)');
            ylabel('Msg (F)');
            grid on;
        end
    end
end