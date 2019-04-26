classdef ModulationModel < handle
    properties
       % General Parameter
       N
       Fs

       % Signals
       msg
       msg_mod
       msg_canal
       y_BPF
       y_D
       y_LPF
       
       y_A
       y_B
       y_C
       y_D
       y_E

       % Modulation
       ModType
       Fc
       A

       % Channel
       NoiseState
       NoisePower

       % Detector
       Phase
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
        %   1: Archivo 1
        %   2: Archivo 2
        %   3: Tono 0,5V@1000Hz
        %   4: Tono 1,0V@10000Hz
        %   5: Tono 0,8V@20000Hz
            switch selector
                case 1
                    % Carga el archivo 1
                    data = load('arch1.mat');
                    obj.msg = data.msg1(1:obj.N,:);       % Ajusta el numero de muestras
                case 2
                    % Carga el archivo 2
                    data = load('arch2.mat');
                    obj.msg = data.y_rf_tot(1:obj.N,:);       % Ajusta el numero de muestras
                case 3
                    obj.msg = 0.5*sin(2*pi*1000*obj.t);
                case 4
                    obj.msg = sin(2*pi*10000*obj.t);
                case 5
                    obj.msg = 0.8*sin(2*pi*20000*obj.t);
            end
        end

        % Simulacion de modulacion
        function obj = modulador(obj, fc, freqdev)
            obj.msg_mod = fmmod(obj.msg, fc, obj.fs, freqdev);
        end

        % Simulacion del canal
        function obj = canal(obj, selector_ruido, Pr)
            obj.NoiseState = selector_ruido;
            obj.NoisePower = Pr;
            switch selector_ruido
                case 'ON'
                    obj.msg_canal = obj.msg_mod + wgn(1, obj.N, Pr, 'linear');
                case 'OFF'
                    obj.msg_canal = obj.msg_mod;
            end
        end

        % Simulacion del filtro pasabanda, detector sincrono y filtro pasabajo
        function obj = receptor(obj, Flo, freqdev, W_IF, W)
            %obj.Phase = fase_detector;
            %obj.y_BPF = bandpass(obj.msg_canal, obj.f_bpf, obj.Fs);
            %obj.y_D = amdemod(obj.y_BPF, obj.Fc, obj.Fs, fase_detector);  
            %obj.y_LPF = lowpass(obj.y_D, obj.f_lpf, obj.Fs);
        end

        function dispPower(obj)
            % Message's power
            power_msg = obj.PowerRMS(obj.msg);

            % Message modulated's power
            power_msg_mod = obj.PowerRMS(obj.msg_mod);

            % No noise signal version in the receptor.
            y_BPF_no_noise = bandpass(obj.msg_mod, obj.f_bpf, obj.Fs);
            y_D_no_noise = amdemod(y_BPF_no_noise, obj.Fc, obj.Fs, obj.Phase);
            y_LPF_no_noise = lowpass(y_D_no_noise, obj.f_lpf, obj.Fs);

            % Banda Pass Filter's power
            power_signal_BPF = obj.PowerRMS(obj.y_BPF);
            power_noise_BPF = obj.PowerRMS(obj.y_BPF - y_BPF_no_noise);

            % Low Pass Filter's power
            power_signal_LPF = obj.PowerRMS(obj.y_LPF);
            power_noise_LPF = obj.PowerRMS(obj.y_LPF - y_LPF_no_noise);
            
            obj.PrintPwrMsgs(power_msg, power_msg_mod);
            obj.PrintPwrSignalNoise("A la salida del filtro pasabanda", power_signal_BPF, power_noise_BPF);
            obj.PrintPwrSignalNoise("A la salida del filtro pasabajo", power_signal_LPF, power_noise_LPF);
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