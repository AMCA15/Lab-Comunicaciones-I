%% Cuantificacion Uniforme y No Uniforme. LAB4 EC2422 (Comunicaciones I) Universidad Sim�n Bol�var
%Armando Longart 10-10844
%Yurjelis Brice�o 11-11371
%% 

%% Cuantificacion Uniforme de Se�al Seno
%close all
N = [4 3 2];
for i=1:3
    n=N(i);
    sim('CuantUnifSin.slx');
    figure
    subplot(2,1,1)
    plot(tout,entrada) 
    hold on
    plot(tout,xq) 
    plot(tout,error)
    title(sprintf('Se�ales en el dominio temporal. n = %d',n))
    xlabel('Tiempo (s)'), 
    ylabel('Amplitud');
    legend('Entrada', 'Cuantizada', 'Error');
    grid on;
    
    
    fs = 1/(tout(2)-tout(1));
    [ENTRADA, fe] = espectro(entrada,fs);
    [XQ, fxq] = espectro(xq,fs);
    [ERROR, ferr] = espectro(error,fs);
    subplot(2,1,2)
    plot(fe,ENTRADA)
    hold on
    plot(fxq,XQ)
    plot(ferr,ERROR)
    title(sprintf('Se�ales en el dominio frecuencial. n = %d',n))
    xlabel('Frecuencia (Hz)')
    ylabel('Magnitud')
    legend('Entrada','Cuantizada','Error')
    grid on;
    
    figure,
    hist(entrada);
    grid on;
    %hist(entrada/length(entrada),100);
    title(sprintf('Histograma de la entrada. n = %d', n));
    figure,
    hist(xq);
    grid on;
    %hist(xq/length(xq),100);
    title(sprintf('Histograma de la se�al cuantizada. n = %d', n));
    figure,
    hist(error);
    grid on;
    %hist(error/length(error),100);
    title(sprintf('Histograma del error. n = %d', n));
    Sq=mean(xq.^2);
    Nq=mean(error.^2);
    fprintf('Sq/Nq = %d para n = %d\n', Sq/Nq, n);
end