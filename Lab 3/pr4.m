% EC1482 Laboratorio de Comunicaciones Digitales
% Versión 2003
% Simulaciones Computarizadas - PRACTICA 8
% Autor: Prof. Renny E. Badra, Ph.D.

clear;

% Personalización de la simulacion
C1 = 1611350;			% número de carnet del integrante 1 (cinco digitos)
C2 = 1001681;			% número de carnet del integrante 2 (cinco digitos)

% Parámetros Básicos e Inicializacion de Variables
rand('state', C1); randn('state', C2);	% inicializacion de los generadores seudoaleatorios
P0 = 0.85; 								% Probabilidad de cero de la fuente
NBIT = 30; 								% número de bits a simular (entero)
m = 3; 									% longitud del bloque (run_length)
SECF = "Secuencia Fuente: ";
SECC = "Secuencia Codigo: ";
NBC = 0;

% Seleccion del Código de Canal
tipo_codigo = input('Codigo a simular? \n[A] Huffman \n[B] Run Length\n', 's');


switch tipo_codigo

    %%%  Codigo Huffman %%%

    case {'a', 'A'}

        fuente = {'000' '001' '010' '011' '100' '101' '110' '111'}; 	% contiene 2^LH strings con todas las palabras binarias de LH bits
        codigo = {'0' '110' '101' '11110' '100' '11101' '11100' '11111'}; 	% mapeo del Codigo Huffman
        LH = length(char(fuente(1))); 		% longitud de la palabra binaria fuente (Huffman)

        NBLOQ = ceil(NBIT/LH); 				% numero de bloques a simular

        % Lazo central empieza aquí
        for nbloq = 1:NBLOQ

            % Generación del caudal de bits
            TBIT = floor(rand+(1-P0)); TBLOQ = num2str(TBIT);
            for k = 2:LH; TBIT = floor(rand+(1-P0)); TBLOQ = strcat(TBLOQ, num2str(TBIT)); end

            % Codificador Huffman
            indice = strmatch(TBLOQ, fuente);
            CBLOQ = codigo(indice);

            % Conteo de bits codificados
            NBC = NBC+length(char(CBLOQ));

            % Guardar secuencias
            if NBIT < 32
                SECF = strcat(SECF, TBLOQ);
                SECC = strcat(SECC, CBLOQ);
            end
        end

        % Resultados
        Tasa_Compresion = NBLOQ*LH/NBC
        Bits_P = 1/Tasa_Compresion;
        NC = strcat(num2str(Bits_P), ' bits codificados por cada bit fuente (NC)'); disp(NC);
        if NBIT < 32; disp(SECF); disp(SECC); end


    %%% Codigo Run_Length %%%
    case {'b', 'B'}

        nbit = 0; flag = 0;

        while nbit < NBIT

            % Codificador Run_Length

            runlength = 0;
            if flag == 0; TBIT = floor(rand+(1-P0)); else; flag = 0; end

            for k = 1:2^m
                if TBIT == 1; break; end
                TBIT = floor(rand+(1-P0));
                runlength = runlength+1;
            end

            if TBIT == 1 && runlength>0; flag = 1;  end
            if runlength == 2^m; flag = 1; end
            if runlength == 0; CBLOQ = '1'; TBLOQ = '1';
            else; CBLOQ = strcat('0', num2str(dec2bin(runlength-1, m))); TBLOQ = dec2bin(0, runlength);
            end

            % Conteo de bits codificados
            NBC = NBC+length(CBLOQ);

            % Guardar secuencias
            if NBIT < 32
                SECF = strcat(SECF, TBLOQ);
                SECC = strcat(SECC, CBLOQ);
            end

            nbit = nbit+length(TBLOQ);
        end

        % Resultados
        Tasa_Compresion = nbit/NBC
        Bits_P = 1/Tasa_Compresion;
        NC = strcat(num2str(Bits_P), ' bits codificados por cada bit fuente (NC)'); disp(NC);
        if NBIT < 32;  disp(SECF); disp(SECC); end

end
