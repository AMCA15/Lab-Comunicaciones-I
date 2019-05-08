% Anderson Contreras
% 16-11350

% For testing different parameters in the FM using the ModulationModel Class

s = ModulationModel;

% Parte 1: Ancho de banda de transmisión, índice de modulación y
% contenido frecuencial del mensaje

% Casos:
%   1: Frecuencia Constante: 1000Hz Fc=20000. B=1
%   2: Frecuencia Constante: 1000Hz Fc=20000. B=2
%   3: Frecuencia Constante: 1000Hz Fc=20000. B=5
%   4: Amplitud Constante:     1    Fc=20000. B=1
%   5: Amplitud Constante:     1    Fc=20000. B=2
%   6: Amplitud Constante:     1    Fc=20000. B=5
%   7: Mensaje de "arch1"           Cociente de Desviación = 1
%   8: Mensaje de "arch1"           Cociente de Desviación = 5
%   9: Mensaje de "arch1"           Cociente de Desviación = 10

selector = 1;

switch selector
    case {1,2,3,4}
        s.mensaje(1);
    case 5
        s.mensaje(2);
    case 6
        s.mensaje(3);
    case {7,8,9}
        s.mensaje(4);
end
switch selector
    case {1,4,5,6}
        s.modulador(20000, 1000);
    case 2
        s.modulador(20000, 2000);
    case 3
        s.modulador(20000, 5000);
    case 7
        s.modulador(20000, 1000);
    case 8
        s.modulador(20000, 5000);
    case 9
        s.modulador(20000, 10000);
end
fftplot(s);




% Parte 2: Receptor superheterodino

% Recuperación de mensajes de señal compuesta
% Casos:
%   1: Mensaje en canal de 20KHz. Música: Por Una Cabeza - The Tango Project
%   2: Mensaje en canal de 35KHz. Música: Love theme from "The Godfather"

Caso = 1;

s.mensaje(5);        % Seleccion señal RF compuesta
s.modulador();       % No se modula ya que la señal está modulada
s.canal();          % Potencia del ruido
switch Caso
    case 1
        s.receptor(6000, 1000);     % Selecciona el canal de 6KHz
    case 2
        s.receptor(21000, 1000);    % Selecciona el canal de 21Khz
end
plot_receptor(s);
s.play();           % Reproduce el sonido demodulado
s.dispPower;




