close all
clear
clc
% ********* Grabacion *********
settings;
disp('Presione una tecla para recibir seÒal')
pause
disp('Recibiendo SeÒal')
t_f = 50; % duracion de la grabacion (segs)
% recobj = audiorecorder(Fs, 16, 1);
% recordblocking(recobj, t_f);
% signal = recobj.getaudiodata;
load('audio.mat');  % prueba canal perfecto
% ********* Header *********
head_t = 0:1/Fs:head_dur;
true_head = [sin(2*pi*f1header*head_t), sin(2*pi*f2header*head_t), sin(2*pi*f3header*head_t)];
test_dur = 4; % segs
test_head = signal(1:test_dur*Fs); % header a detectar (4 segundos de ventana)
% 'acor' contiene la correlacion para cada desplazamiento de 'lag'
[acor, lag] = xcorr(test_head, true_head); % correlacion cruzada
[~,I] = max(abs(acor));  % maxima correlacion
lagDiff = lag(I);  % desviacion en frames donde esta la maxima corr

% ********* Decodificacion dimension imagen *********
% head_init tiene el inicio de donde empieza a codificarse la dimension
head_init = abs(lagDiff) + length(true_head);
L = tam_dur * Fs;  % frames que dura la info de la dimension
body = signal(head_init:head_init + L -1); % info dimension
Z = fft(body);
Z1 = Z(1:(L/2)+1);
Z1(2:end-1) = 2*Z1(2:end-1);
Z1 = abs(Z1);
Z12 = abs(Z1);
efe = Fs*(0:(L/2))/L;
index = (dim1+500 > efe) & (efe >= dim1-500); % indices filtrado
efe = efe(index);
Z1 = Z1(index); % filtrado ;)
[~,f_i] = max(Z1);
efe(f_i);  % encuentra el tono

efe2 = Fs*(0:(L/2))/L;
index2 = (dim2+500> efe2) & (efe2 >= dim2-500); % indices filtrado
efe2 = efe2(index2);
Z12 = Z12(index2); % filtrado ;)
[~,f_i2] = max(Z12);

tam = round((efe(f_i)-dim1)/5);
tam2 = round((efe2(f_i2)-dim2)/5);
lar=num2str(tam);
an=num2str(tam2);
pal=['dimensiones ' lar 'x' an];
disp(pal);
if tam==tam2
    %hasta aqui funcionando
    % ********* Mensaje *********
    init_time = head_init + length(body);
    red = zeros(1, tam*tam2);
    green = zeros(1, tam*tam2);
    blue = zeros(1, tam*tam2);
    pix_t=0:1/Fs:pix_dur;
    pix_wid = length(pix_t);
    f_val = (0:pix_wid/2) * Fs/pix_wid;  % frecuencias de la fft
    message = signal(init_time:end);
L = length(signal);
NFFT = 2^nextpow2(L);
Y = fft(signal, NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
figure (2)
plot(f, 2*abs(Y(1:NFFT/2+1)));
xlabel('Frecuencia [Hz]')
ylabel('Amplitud')


    for i = 1:(tam*tam2)
        sample = message((i-1)*pix_wid+1:i*pix_wid);
        Y = fft(sample); % saca fft por columnas
        Y1 = Y(1:round(pix_wid/2) + 1);
        Y1 = abs(Y1);
        for k=1:8
            indexR =((RbaseF+k*sep-40)>= f_val) & (f_val >= RbaseF+(k-1)*sep-10); %indicando los anchos de banda
            indexG =((GbaseF+k*sep-40)>= f_val) & (f_val >= GbaseF+(k-1)*sep-10);
            indexB =((BbaseF+k*sep-40)>= f_val) & (f_val >= BbaseF+(k-1)*sep-10);
            Y1r= Y1(indexR);
            Y1r= abs(Y1r); 
            Y1g= Y1(indexG);
            Y1g= abs(Y1g);
            Y1b= Y1(indexB);
            Y1b= abs(Y1b);
            Rf_val = f_val(indexR);
            Gf_val = f_val(indexG);
            Bf_val = f_val(indexB);
            [~, indr] = max (Y1r); % encuentra m√°xima frecuencia en la banda del rojo
            [frecg,indg] = max (Y1g);
            [frecb,indb] = max (Y1b); 
            alpix(k)=round((Rf_val(indr)-RbaseF-sep*(k-1))/dF);
            alpix(k+8)=round((Gf_val(indg)-GbaseF-sep*(k-1))/dF);
            alpix(k+16)=round((Bf_val(indb)-BbaseF-sep*(k-1))/dF);
        end
        red(i) = bi2de(alpix(1:8)); % guarda el valor r del pixel
        green(i) =  bi2de(alpix(9:16)); % guarda el valor g del pixel
        blue(i) =  bi2de(alpix(17:24)); % guarda el valor b del pixel
    end
end
            
    red8 = uint8(reshape(red, tam, tam2)); % Matriz con valores de rojo
    green8 = uint8(reshape(green, tam, tam2)); % Matriz con valores de verde
    blue8 = uint8(reshape(blue, tam, tam2)); % Matriz con valores de azul
    imgrec = cat(3,red8',green8',blue8'); % Imagen reconstruida
    true_img = imread(foto);
    figure (1)
    subplot(1,2,1)
    imshow(imgrec);
    xlabel('Recibida')
    subplot(1,2,2)
    imshow(true_img);
    xlabel('Original')
    umbral=50;

