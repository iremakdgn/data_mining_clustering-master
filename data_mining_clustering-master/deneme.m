dosyaPozisyon='01';
sonucArray=[];

tarih=[];
sayac=0;
for a=1:70
    if(a>9)
    dosyaPozisyon=(num2str(a)); 
    else
        dosyaPozisyon=(strcat('0',num2str(a)));
    end
    dosyaAdi=strcat('data/data-',dosyaPozisyon);
    fileID = fopen(dosyaAdi,'r');
formatSpec ='%s %s %s %s';
data = textscan(fileID,formatSpec);


    tarih=data(1);
    saat=data(2);
    x=data(3);
    y=data(4);
    tarih=tarih{:};
    saat=saat{:};
    x=x{:};
    y=y{:};
   [en,boy,boyut]=size(tarih);
    for j=1:en
        
        sonucArray(a,1)=str2double(x(j));
        sonucArray(a,2)=str2double(y(j));
    end
end
