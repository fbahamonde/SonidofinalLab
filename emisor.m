close all
clear
clc
%********* PARAMETROS *********
settings;
img = imread(foto);
[row, col , deep]= size(img); 
signal = []; 

%********* HEADER *********
% Secuencia de 5k, 6k, y 7k 
head_t = 0:1/Fs:head_dur; 
header = [sin(2*pi*f1header*head_t), sin(2*pi*f2header*head_t), sin(2*pi*f3header*head_t)];
signal = [signal, header];

%********* Codificacion de dimension de la imagen *********
tam_t = 0:1/Fs:tam_dur;
header = sin(2*pi*(dim1+col*5)*tam_t)+ sin(2*pi*(dim2+row*5)*tam_t);
g=length(header);
% ff=fft(header);
% Z1 = ff(1:(g/2)+1);
% Z1(2:end-1) = 2*Z1(2:end-1);
% Z1 = abs(Z1);
signal = [signal, header];

%********* MESSAGE *********
pix_t = 0:1/Fs:pix_dur;
for i=1:row
   	for j=1:col
        pix=[img(i,j,1) img(i,j,2) img(i,j,3)];
        pix = double(pix);
        pixbi=[de2bi(pix(1),8) de2bi(pix(2),8) de2bi(pix(3),8)];
            for k=1:8
                frecP(k)=RbaseF+double(pixbi(k))*dF+sep*(k-1);  
                frecP(k+8)=GbaseF+double(pixbi(k+8))*dF+sep*(k-1);
                frecP(k+16)=BbaseF+double(pixbi(k+16))*dF+sep*(k-1);
            end
 		sample = sin(2 * pi * frecP.' * pix_t);
		sample = sum(sample);
  		signal = [signal, sample];
    end
end
save('audio.mat','signal');
disp('presiona una tecla para continuar')
pause
%sound(signal, Fs)
% pause(50)
% tcpipClient = tcpip(ip,50000,'NetworkRole','Client')
% %set(tcpipClient,'InputBufferSize',150);
% fopen(tcpipClient);
% rawData = fread(tcpipClient,62,'char')';
% unicodestr = native2unicode(rawData)




