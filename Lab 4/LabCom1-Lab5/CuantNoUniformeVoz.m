%% Cuantificacion Uniforme y No Uniforme. LAB5 EC2422 (Comunicaciones I) Universidad Simón Bolívar
%Armando Longart 10-10844
%Yurjelis Briceño 11-11371
%% 

%% Cuantificacion No Uniforme Señal de Voz
close all
N=[6 4];
[entrada, fs]=audioread('prueba.wav');
xmax=max(entrada);
t=[(0:length(entrada)-1)/fs]';
for i=1:2
    n=N(i);
    sim('CuantNoUnifVoz.slx');
    
    if n==4
        figure
        plot(entrada, xqu_decom(1:length(entrada)));
        title('Curva característica del cuantificador con n = 4');
        grid on;
    end
    figure
    subplot(2,1,1)
    plot(t,entrada)
    hold on
    plot(tout,xqu_decom)
    plot(tout,uerror)
    title(sprintf('Gráfica en el dominio temporal. n = %d',n))
    xlabel('Tiempo (s)')
    ylabel('Amplitud')
    legend('Entrada', 'Cuantizada', 'Error')
    grid on;
    
    fs=1/(tout(2)-tout(1));
    [ENTRADA, fe]=espectro(entrada, fs);
    [XQ, fxq]=espectro(xqu_decom, fs);
    [ERROR, ferr]=espectro(uerror, fs);
    
    subplot(2,1,2)
    plot(fe,ENTRADA)
    hold on
    plot(fxq,XQ)
    plot(ferr,ERROR)
    title(sprintf('Gráfica en el dominio frecuencial. n = %d',n))
    xlabel('Frecuencia (Hz)')
    ylabel('Amplitud')
    legend('Entrada', 'Cuantizada', 'Error')
    grid on;
    
    figure
    hist(entrada)
    title(sprintf('Histograma de la entrada n = %d', n))
    grid on;
    
    figure
    hist(xqu_decom)
    title(sprintf('Histograma de la senal cuantizada n = %d', n))
    grid on;
    
    figure
    hist(uerror)
    title(sprintf('Histograma del error n = %d', n))
    grid on;
    
    Sq=mean(xqu_decom.^2);
    Nq=mean(uerror.^2);
    fprintf('Sq/Nq = %d para n = %d\n', Sq/Nq, n)
    
    sound(xqu_decom, fs)
end