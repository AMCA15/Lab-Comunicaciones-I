%% Cuantificacion Uniforme y No Uniforme. LAB5 EC2422 (Comunicaciones I) Universidad Simón Bolívar
%Armando Longart 10-10844
%Yurjelis Briceño 11-11371
%% 

%% Cuantificacion Uniforme de Señal de Voz
%close all
N=[6 4];
[entrada, fs]=audioread('prueba.wav');
sound(entrada,fs);
t=[(0:length(entrada)-1)/fs]';
for i=1:2
    n=N(i);
    sim('CuantUnifVoz.slx');
    
    if n==4
        figure,
        plot(entrada, xq(1:length(entrada)));
        title('Curva caracteristica del cuantificador con n = 4');
        grid on;
    end
    
    figure
    subplot(2,1,1)
    plot(t,entrada)
    hold on;
    plot(tout,xq)
    plot(tout,error)
    title(sprintf('Gráficas en el dominio temporal. n = %d',n))
    xlabel('Tiempo (s)')
    ylabel('Amplitud')
    legend('Entrada', 'Cuantizada', 'Error');
    grid on;
    
    fs = 1/(tout(2)-tout(1));
    [ENTRADA, fe] = espectro(entrada, fs);
    [XQ, fxq] = espectro(xq, fs);
    [ERROR, ferr] = espectro(error, fs);
    
    subplot(2,1,2);
    plot(fe,ENTRADA)
    hold on
    plot(fxq,XQ)
    plot(ferr,ERROR)
    title(sprintf('Gráficas en el dominio frecuencial. n = %d',n))
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud');
    legend('Entrada', 'Cuantizada', 'Error');
    grid on;
    
    figure
    hist(entrada)
    title(sprintf('Histograma de la entrada. n = %d', n));
    grid on;
    
    figure,
    hist(xq)
    title(sprintf('Histograma de la señal cuantizada. n = %d', n));
    grid on;
    
    figure
    hist(error);
    title(sprintf('Histograma del error. n = %d', n))
    grid on;
    
    Sq=mean(xq.^2);
    Nq=mean(error.^2);
    fprintf('Sq/Nq = %d para n = %d\n', Sq/Nq, n)
    
    sound(xq, fs)
end