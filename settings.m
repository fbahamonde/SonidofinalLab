Fs=40 * 10^3;  % sample rate 
% duracion (tiempo) de cada tono del header
head_dur = 0.3; %0.6
% duracion (tiempo) donde esta el dimension de la imagen
tam_dur = 0.15; %0.3
% duracion (tiempo) de ventana donde esta el pixel
pix_dur = 0.175; % 0.35 
% funciones para pasar de frecuencia al valor del pixel 
RbaseF = 2000;
GbaseF = 6000;
BbaseF = 10000;
f1header=5000;
f2header=6000;
f3header=7000;
dim1=5600;
dim2=2000;
sep=100;
dF = 50; % diferencia entre cada valor del pixel
p2f = @(pix, base, df) base + pix*df;
f2p = @(frec, bf, df) round((frec-bf)/df);
foto='angel.png';
ip='colocarip';
confirmacion='El mensaje llego a destino';
reenviar='El mensaje no llego a destino';
