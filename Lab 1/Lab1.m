% Anderson Contreras
% For testing different parameters in the AM and DSB-SC modulation using the
% ModulationModel Class

s = ModulationModel;

switch(2)
    % Cases with differents tones and AM modulation
    % Tono 0,5V@100Hz. AM, u = 1, fc = 10000. Power Noise = 0. Phase Receptor = 0
    case 1
        s.mensaje(2);
        s.modulador('AM', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9900 10100];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 100;              % Set the lowpass cut-off frecuency
        s.receptor(0);
    
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
        s.canal('ON', 0.1);
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
        s.canal('ON', 0.1);
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
        s.receptor(45);
        
    % Tono 1,0V@1000Hz. AM, u = 1, fc = 10000. Power Noise = 0,5. Phase Receptor = 90 
    case 12
        s.mensaje(3);
        s.modulador('AM', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(90);
        
    % Cases with phase in the receptor different to 0. DSB
    % Tono 1,0V@1000Hz. DSB, fc = 10000. Power Noise = 0. Phase Receptor = 45
    case 13
        s.mensaje(3);
        s.modulador('DSB', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(45);
        
    % Tono 1,0V@1000Hz. DSB, fc = 10000. Power Noise = 0. Phase Receptor = 90
    case 14
        s.mensaje(3);
        s.modulador('DSB', 10000, 1);
        s.canal('OFF', 0);
        s.f_bpf = [9000 11000];     % Set the bandpass cut-off frecuencies
        s.f_lpf = 1000;             % Set the lowpass cut-off frecuency
        s.receptor(90);
end

s.dispPower;
plot(s);