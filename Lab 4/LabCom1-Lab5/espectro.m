%% Cuantificacion Uniforme y No Uniforme. LAB5 EC2422 (Comunicaciones I) Universidad Simón Bolívar
%Armando Longart 10-10844
%Yurjelis Briceño 11-11371
%% 

function [MX, f] = espectro(x, Fs)

    %Vía 1
%     X=fftshift(fft(x))/length(x);
%     L=length(x);
%     f=(-L/2:L/2-1)*Fs/L;
    
    %Vía 2
    X=abs(fftshift(fft(x)));
    N=length(X);
    MX=X/N;
    f=-Fs/2:Fs/N:Fs/2-Fs/N;
    
    
%     %Vía 3
%     X=fftshift(fft(x));
%     MX=abs(X); % Se busca el modulo de X
%     N=length(MX);
%     MX=MX/N;
%     f=-fs/2:fs/N:fs/2-fs/N;
 

end