function [VectorDacTrung] = TimVectorDacTrung()
% Ham tim vector dac trung
% Ket qua la 1 ma tran 5 * DoDaiVectorDacTrung_fft chua 5 vector dac trung cua 5 nguyen am
 
NguyenAm = {'a','e','i','o','u'};
TenFolder={'23MTL','24FTL','25MLM','27MCM','28MVN','29MHN','30FTN','32MTP','33MHP','34MQP','35MMQ','36MAQ','37MDS','38MDS','39MTS','40MHS','41MVS','42FQT','43MNT','44MTT','45MDV'};


DoDaiVectorDacTrung_fft = 1024;                        % N_FFT                    
VectorDacTrung=zeros(5,DoDaiVectorDacTrung_fft);   
DoDaiKhung = 0.02;                                                    
DoDichKhung = 0.02;                                                                                            
figure;
hold on
 for k = 1 : 5
     for i= 1 : length(TenFolder)
         path = char(strcat('NguyenAmHuanLuyen-16k/',cell2mat(TenFolder(i)),'/',cell2mat(NguyenAm(k)),'.wav'));
         [x,fs] = audioread(path);                                      
         x = x / max(abs(x));  % chuan hoa tin hieu ve day -1 1
         [x] = CatKhoangLang(x,fs,0.01);                            
         [x] = LayDoanOnDinh(x);                                      
         SoLuongKhung = floor((size(x,1) - DoDaiKhung*fs)/(DoDichKhung*fs)) + 1;  % tinh so luong khung
         TongcacVector = 0;                                                               % vector tong cac vector fft
         for j=1:SoLuongKhung                                         
             [frame] = Chiakhung(x, fs, DoDaiKhung, DoDichKhung, j);                           
             [result] = FFT(frame, DoDaiVectorDacTrung_fft);                                                 
             TongcacVector = TongcacVector + result;                                           
         end
         TongcacVector = TongcacVector/SoLuongKhung;  % vector fft tb (1 nguyen am/ 1 nguoi noi)
         TongcacVector = TongcacVector(1:length(TongcacVector)/2);  % lay 1 nua vector (vi la vector doi xung)                 
         for m =1:length(TongcacVector) 
             VectorDacTrung(k,m)=VectorDacTrung(k,m)+TongcacVector(m);   % tong cac vector fft cua nhieu nguoi noi
         end
        
     end
     for m =1:length(TongcacVector)
         VectorDacTrung(k,m)=VectorDacTrung(k,m)/21;      % vector fft trung binh cua 1 nguyen am 
     end
        
     p = VectorDacTrung(k,:); 
     plot(p);
 end
 legend('/a/', '/e/', '/u/', '/i/', '/o/');          
end