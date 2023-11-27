close; clear; clc;

NguyenAm = {'a','e','i','o','u'};
TenFolder = {'01MDA','02FVA','03MAB','04MHB','05MVB','06FTB','07FTC','08MLD','09MPD','10MSD','11MVD','12FTD','14FHH','15MMH','16FTH','17MTH','18MNK','19MXK','20MVK','21MTL','22MHL'};
% goi ham va truyen thong so vao cho cac bien
MaTranNhamLan=zeros(6,6);                    
[VectorDacTrung] = TimVectorDacTrung(); 
SoPhanTuVector_fft = 1024;         % N_FFT:128, 256, 512, 2048,4096,...       
DoDaiKhung = 0.02;                               
DoDichKhung = 0.02;                            
NguongXacDinhcuaKhoangLang =0.01;
% duyet lan luot tung nguyen am cua tung folder kiem thul
for i = 1 : length(TenFolder)
    disp(strcat('File : ',TenFolder(i)))
    for j = 1 : length(NguyenAm)
        path = char(strcat('NguyenAmKiemThu-16k/',TenFolder(i),'/',NguyenAm(j),'.wav'));
        [x, fs] = audioread(path);                  
        x = x / max(abs(x));        % chuan hoa tin hieu ve day -1 : 1
        [x] = CatKhoangLang(x,fs,NguongXacDinhcuaKhoangLang);           
        [x] = LayDoanOnDinh(x);                    
        SoLuongKhung = floor((size(x,1) - DoDaiKhung*fs)/(DoDichKhung*fs)) + 1;% tinh so luong khung
        TongcacVector = 0;                  % vector tong cac vector fft
        for m=1:SoLuongKhung                               
            [frame] = Chiakhung(x, fs, DoDaiKhung, DoDichKhung, m);         
            [result] = FFT(frame, SoPhanTuVector_fft);                                    
            TongcacVector = TongcacVector + result';           % tong cac vector fft
        end 
        TongcacVector = TongcacVector/SoLuongKhung;            % vector fft trung binh (1 nguyen am/1 nguoi noi)
        TongcacVector = TongcacVector(1:length(TongcacVector)/2);      % lay 1 nua vector (vi la vector doi xung)
        
        array = zeros(1,5);      % mang chua khoang cach giua VDT vua tinh voi VDT cua file huan luyen
        for m =1:5                                             
            vantay = VectorDacTrung(m,:);           % trich 1 vector dac trung cua 1 nguyen am 
            array(m) = KhoangCachEuclidean(TongcacVector,vantay);           
        end
        [value,index] = min(array);          % nguyen am co khoang cach be nhat se la ket qua can tim
        
        % so sanh ket qua dat duoc voi ket qua chuan
        if(index==j) 
            disp(strcat('Nguyen am :', NguyenAm(j),' - Ket qua thu duoc : ',NguyenAm(j)));
            MaTranNhamLan(j,j)=MaTranNhamLan(j,j) +1; 
        else 
            disp(strcat('Nguyen am : ', NguyenAm(j), ' - Ket qua thu duoc : ',NguyenAm(index),'  -> Sai ' ));
            MaTranNhamLan(j,index)=MaTranNhamLan(j,index)+1; 
        end
    end
    disp('-------------------------------------------------- ');
end

DoChinhXacA = MaTranNhamLan(1, 1) / 21 * 100;
DoChinhXacE = MaTranNhamLan(2, 2) / 21 * 100;
DoChinhXacI = MaTranNhamLan(3, 3) / 21 * 100;
DoChinhXacO = MaTranNhamLan(4, 4) / 21 * 100;
DoChinhXacU = MaTranNhamLan(5, 5) / 21 * 100;

tong = (DoChinhXacA + DoChinhXacE + DoChinhXacI + DoChinhXacO + DoChinhXacU) / 5;

MaTranNhamLan(1, 6) = DoChinhXacA;
MaTranNhamLan(2, 6) = DoChinhXacE;
MaTranNhamLan(3, 6) = DoChinhXacI;
MaTranNhamLan(4, 6) = DoChinhXacO;
MaTranNhamLan(5, 6) = DoChinhXacU;
MaTranNhamLan(6, 6) = tong;
figure;
uitable('Data', MaTranNhamLan, 'ColumnName', {'a', 'e', 'i', 'o', 'u', '?? chính xác (%)'}, 'RowName', {'a', 'e', 'i', 'o', 'u', '?? chính xác TB'}, 'Units', 'Normalized', 'Position', [0, 0, 1, 1]);
