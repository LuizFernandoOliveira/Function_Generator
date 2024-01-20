clc
close all
clear all

Np = 5000;
dt = 1/20000;        % amostragem;
T = Np*dt;
t = 0:dt:T-dt;       % vetor de tempo

A  = 0.0025;         % amplitude
ff = 7900;           % frequencia final
df = 1/(Np*dt);      % decalagem da frequencia
Nh =(ff/df);         % numero de harmonicas

u = 0;
for k = 0: Nh-1      % calcula a soma de cossenos
    fi = -k*(k-1)*pi/Nh; 
    u = u + A*cos(2*pi*(k+1)*df*t+fi);
end

N=length(u);   
f1=(0:N-1)*df; 
Y = (1/N)*fft (u);  % calcula a transformada de fourier 
Y = Y(1:N/2);       % metade do vetor
f1 = f1(1:N/2);

% figure(1)
% subplot(2,1,1)      % Sinal no tempo
% plot(t,u)
% xlabel('Tempo [s]')
% ylabel('Amplitude')
% grid
% subplot(2,1,2)      % Sinal na frequência
% stem(f1,abs(Y))
% xlabel('Frequência [Hz]')
% ylabel('Amplitude')
% grid

maximo = max(u);
minimo = min(u);

Id = ones(1,Np);
vec_aux = minimo*Id;
uN_byte = uint8( (100/(maximo-minimo))*(u-vec_aux)  );

fileID = fopen('dados.txt','w');
fprintf(fileID,"static byte Sinal[Np] = {\n");
for i=1:10
    for j=1:(Np/10)
        if ((i == 10) && j == (Np/10))
            fprintf(fileID,"0x%x",uN_byte((Np/10)*(i-1)+j));
        else
            fprintf(fileID,"0x%x,",uN_byte((Np/10)*(i-1)+j));
        end
    end
    fprintf(fileID,"\n");
end
fprintf(fileID,"};");
fclose(fileID);

fprintf("\nArquivo gerado com sucesso!\n\n");