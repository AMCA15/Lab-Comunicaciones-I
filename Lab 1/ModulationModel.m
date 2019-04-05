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
    properties (SetAccess = private, Hidden)
       t                     % Escala de tiempo
       F                     % Escala de frecuencia
    end
    
    methods
        function obj = ModulationModel
           obj.N = 20000;
           obj.Fs = 90000;
           obj.Fc = 10000;
           obj.t = (1:obj.N)/obj.Fs;
           obj.f_bpf = [8000 12000];      % Pasa Banda
           obj.f_lpf = 2000;              % Pasa Bajo
           obj.F = -(obj.Fs-obj.Fs/obj.N)/2:obj.Fs/obj.N:(obj.Fs-obj.Fs/obj.N)/2;
        end
        
        function obj = mensaje(obj, selector)
        % Seleccion del mensaje
        %   1: Archivo de Sonido
        %   2: Tono 0,5V@100Hz
        %   3: Tono 1,0V@1000Hz
        %   4: Tono 0,8V@2000Hz
            switch selector
                case 1
                    % Carga el archivo de sonido
                    load('archivo1.mat');
                    obj.msg = sonido(1:200000,:);   % Ajusta el numero de muestras
                    obj.msg = obj.msg - mean(obj.msg);      % Elimina la componente DC
                    obj.msg = rescale(obj.msg,-1,1);    % Ajusta el valor mï¿½ximo a la unidad
                case 2
                    obj.msg = 0.5*sin(2*pi*100*obj.t);
                case 3
                    obj.msg = sin(2*pi*1000*obj.t);
                case 4
                    obj.msg = 0.8*sin(2*pi*2000*obj.t);
            end
        end
        
        % Simulacion de modulacion
        function obj = modulador(obj, selector_modulacion, fc, u)
            ka = 1;
            obj.Fc = fc;
            obj.ModType = selector_modulacion;
            obj.A = u;
            switch(selector_modulacion)
                case 'AM'
                    obj.msg_mod = ka*(1 + u*obj.msg).*cos(2*pi*fc*obj.t);
                case 'DSB'
                    obj.msg_mod = ka*obj.msg.*cos(2*pi*fc*obj.t);           
            end
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
        function obj = receptor(obj, fase_detector)
            obj.Phase = fase_detector;
            obj.y_BPF = bandpass(obj.msg_canal, obj.f_bpf, obj.Fs);
            obj.y_D = obj.y_BPF.*cos(2*pi*obj.Fc*obj.t+fase_detector);
            obj.y_LPF = lowpass(obj.y_D, obj.f_lpf, obj.Fs);
        end
        
       
        function dispPower(obj)
            % Message's power
            power_msg = round(rms(obj.msg)^2, 3, 'decimals');
            
            % Message modulated's power
            power_msg_mod = round(rms(obj.msg_mod)^2, 3, 'decimals');
            
            % No noise signal version in the receptor.
            y_BPF_no_noise = bandpass(obj.msg_mod, obj.f_bpf, obj.Fs);
            y_D_no_noise = y_BPF_no_noise.*cos(2*pi*obj.Fc*obj.t+obj.Phase);
            y_LPF_no_noise = lowpass(y_D_no_noise, obj.f_lpf, obj.Fs);
            
            % Banda Pass Filter's power
            power_signal_BPF = round(rms(obj.y_BPF)^2, 3, 'decimals');
            power_noise_BPF = round(rms(obj.y_BPF - y_BPF_no_noise)^2, 3, 'decimals');
            s_n_BPF = round(power_signal_BPF / power_noise_BPF, 2, 'decimals');
            
            % Low Pass Filter's power
            power_signal_LPF = round(rms(obj.y_LPF)^2, 3, 'decimals');
            power_noise_LPF = round(rms(obj.y_LPF - y_LPF_no_noise)^2, 3, 'decimals');
            s_n_LPF = round(power_signal_LPF / power_noise_LPF, 2, 'decimals');
            
            disp("======================================");
            disp("Potencia del mensaje: " + power_msg);
            disp("======================================");
            disp("A la salida del transmisor");
            disp("Potencia de la señal: " + power_msg_mod);
            disp("======================================");
            disp("A la salida del filtro pasabanda");
            disp("Potencia de la señal: " + power_signal_BPF);
            disp("Potencia del ruido: " + power_noise_BPF);
            disp("Relacion señal a ruido: " + s_n_BPF + " (" + round(mag2db(s_n_BPF), 2, 'decimals') + " dB)");
            disp("======================================");
            disp("A la salida del filtro pasabajo");
            disp("Potencia de la señal: " + power_signal_LPF);
            disp("Potencia del ruido: " + power_noise_LPF);
            disp("Relacion señal a ruido: " + s_n_LPF + " (" + round(mag2db(s_n_LPF), 2, 'decimals') + " dB)");
        end
        
        function plot(obj)
            obj.plot_template1('Mensaje Original', obj.msg);
            obj.plot_template1('Mensaje Modulado', obj.msg_mod);
            obj.plot_template1('Mensaje en el Canal', obj.msg_canal);
            obj.plot_template2('Mensaje en el Receptor', 2, 3, [obj.y_BPF, obj.y_D, obj.y_LPF], ['Pasa Banda', 'Detector', 'Pasa Bajo']);
        end      
        
        function plot_template1(obj, Title, Signal)
            figure('Name', Title);
            % Graficar señal en tiempo
            subplot(2,1,1);
            plot(obj.t, Signal);
            axis([0 0.025 -1 1]);
            obj.plot_labels_time();

            % Graficar espectro de la señal
            subplot(2,1,2);
            M=abs(fftshift(fft(Signal)));
            M=M/obj.N;
            plot(obj.F,M);
            axis([-3000 3000 0 0.5])
            plot_labels_frecuency(obj)
            grid on 
        end
        
        function plot_template2(obj, Title, Rows, Columns, Signals, SignalsName)
            figure('Name', Title);
            % Graficar señal en tiempo
            for i = 1:Rows*Columns - 1
                subplot(Rows,Columns,i);
                plot(obj.t, Signals(i));
                obj.plot_labels_time();
                title('Señal en el tiempo: ' + SignalsName(i));
                axis([0 0.01 -1 1])    
                
                
                subplot(Rows,Columns,i+1);
                M=abs(fftshift(fft(Signals(i))));
                M=M/obj.N;
                plot(obj.F,M);
                obj.plot_labels_frecuency()
                title('Espectro de Frecuencia: ' + SignalsName(i));
                axis([-15000 15000 0 0.5])
            end
        end
        
        % Agrega etiquetas de graficas de tiempo
        function plot_labels_time(obj)
            title('Señal en el tiempo');
            xlabel('Tiempo (s)');
            ylabel('Msg Mod (t)');
            grid on;
        end

        % Agrega etiquetas en graficas de frecuencia
        function plot_labels_frecuency(obj)
            title('Espectro de Frecuencia');
            xlabel('Frecuencia (Hz)');
            ylabel('Msg (F)');
            grid on;
        end
        
    end
end