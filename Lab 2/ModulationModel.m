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
       Freqdev_D
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
           obj.f_bpf = [8000 12000];      % Pasa Banda
           obj.f_lpf = 2000;              % Pasa Bajo
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
                    obj.msg = sin(2*pi*1000*2*obj.t);
                    
                case 3
                    obj.msg = sin(2*pi*1000*3*obj.t);
                
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
                    obj.msg_mod = fmmod(obj.msg, fc, obj.Fs, freqdev);                    
            end
        end

        % Simulacion del canal
        function obj = canal(obj, Pr)
            switch nargin
                case 1                      % Si no se pasan argumentos no se agrega ruido a la señal
                    obj.msg_canal = obj.msg_mod;
                otherwise
                    obj.NoisePower = Pr;
                    obj.msg_canal = obj.msg_mod + wgn(1, obj.N, Pr, 'linear');
            end
        end

        % Simulacion del filtro pasabanda, detector sincrono y filtro pasabajo
        function obj = receptor(obj, flo, freqdev)
            obj.Flo = flo;
            obj.FreqDev = freqdev;
            
            obj.y_A = obj.msg_canal;
            obj.y_B = ammod(obj.y_A, obj.Flo, obj.Fs);
            obj.y_C = bandpass(obj.y_B, obj.f_bpf, obj.Fs);
            obj.y_D = fmdemod(obj.y_C, obj.Flo, obj.Fs, obj.FreqDev);
            obj.y_E = lowpass(obj.y_D, obj.f_lpf, obj.Fs);
        end

        function dispPower(obj)
            % Power of the message received
            power_sr = obj.PowerRMS(obj.msg_mod);
            
            % Power of the noise received
            power_nr = obj.PowerRMS(obj.msg_mod - obj.msg_canal);

            % Power of the message detected
            power_sd = obj.PowerRMS(obj.y_E);
            
            A = obj.msg_mod - obj.msg_canal;
            B = ammod(A, obj.Flo, obj.Fs);
            C = bandpass(B, obj.f_bpf, obj.Fs);
            D = fmdemod(C, obj.Flo, obj.Fs, obj.FreqDev);
            E = lowpass(D, obj.f_lpf, obj.Fs);
            
            % Power of the noise detected
            power_nd = obj.PowerRMS(E);
            
            %obj.PrintPwrMsgs(power_msg, power_msg_mod);
            obj.PrintPwrSignalNoise("Señal recibida", power_sr, power_nr);
            obj.PrintPwrSignalNoise("Señal detectada", power_sd, power_nd);
        end

        % Plot modulated signal
        function fftplot(obj)
            fftplot(obj.msg_mod, obj.Fs);
            obj.plot_labels_frecuency(" Señal Modulada");
        end        
        
        % Plot time domain and frequency domain
        function plot(obj)
            obj.plot_layout('Mensaje Original', 2, 1, 'Vertical', obj.msg, "");
            obj.plot_layout('Mensaje Modulado', 2, 1, 'Vertical', obj.msg_mod, "");
            obj.plot_layout('Mensaje en el Canal', 2, 1, 'Vertical', obj.msg_canal, "");
            obj.plot_layout('Mensaje en el Receptor', 3, 2, 'Horizontal', [obj.y_BPF; obj.y_D; obj.y_LPF], [": Pasa Banda"; ": Detector"; ": Pasa Bajo"]);
        end
    end

    methods (Hidden)
        function plot_layout(obj, Title, Rows, Columns, Orientation, Signals, SignalsName)
            figure('Name', Title);

            if Orientation == "Horizontal"
               Index = Rows;
            else
               Index = Columns;
            end

            for i = 1:Index
                % Graficar señal en tiempo
                subplot(Rows,Columns,(i*2-1));
                plot(obj.t, Signals(i,:));
                obj.plot_labels_time(SignalsName(i));
                % Plot only 4 periods
                [~, locs] = findpeaks(obj.msg, obj.Fs);
                xUpperLim = mean(diff(locs))*4;
                axis([0 xUpperLim -inf inf])

                % Graficar señal en frecuencia
                subplot(Rows,Columns,i*2);
                M = abs(fftshift(fft(Signals(i,:))));
                M = M / obj.N;
                plot(obj.F, M);
                obj.plot_labels_frecuency(SignalsName(i))
                axis([-15000 15000 -inf inf])
            end
        end
    end
    methods (Static)
        function power = PowerRMS(Signal)
           power = round(rms(Signal)^2, 3, 'decimals');
        end
        
        function PrintPwrMsgs(power_msg, power_msg_mod)
            disp("======================================");
            disp("Potencia del mensaje: " + power_msg);
            disp("======================================");
            disp("A la salida del transmisor");
            disp("Potencia de la señal: " + power_msg_mod);
        end
        
        function PrintPwrSignalNoise(title, power_signal, power_noise)
            sn = round(power_signal / power_noise, 2, 'decimals');
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