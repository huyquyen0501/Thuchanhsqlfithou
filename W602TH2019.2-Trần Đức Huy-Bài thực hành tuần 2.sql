use quanlibanhang;
#2.1a
insert into tblLoaihang values("DT","Điện thoại"),("MT","Máy tính"),("lap","Lap top");
#2.1c
insert into tblNhacungcap (stennhacc,stengiaodich,sdiachi,sdienthoai) values("Samsung","SS","Han Quoc","0987112222"),("Asus","Asus","Mỹ","0347777777"),("Intel","Intel","My","0123456789");
#2.1b
insert into tblMathang values("N4010","Samsung galaxy note 4","1","DT",1000,5000000,"dong"),
							("N9000","Samsung galaxy note 9","1","DT",200,25000000,"dong"),
                            ("N10","Samsung galaxy note 10","1","DT",100,30000000,"dong"),
                            ("K401U","Laptop Asus k401U","2","lap",1000,1100000,"dong"),
                            ("F901HQ","Laptop Asus F901HQ","2","lap",1000,2100000,"dong"),
                            ("110iU","Laptop Asus 110iJ","2","lap",1000,1500000,"dong"),
                            ("i3","chip i3","3","MT",100,3000000,"dong"),
                            ("i5","chip i5","3","MT",100,500000,"dong"),
                            ("i9","chip i9","3","MT",20,1100000,"dong");
#2.2a                            
insert into tblNhanvien(iManv,stennv,sdiachi,sdienthoai,dngaysinh,dngayvaolam,fluongcoban,fphucap,scmnd) 
values(1,"Huy","Ha Noi",01647112405,'1997-04-28','2018-10-20',4000000,1000000,01234444),
	(2,"Sơn","Ha Nam",01647112905,'1997-10-28','2012-11-20',5000000,1000000,123172312),
	(3,"ursa","dota2",01647112405,'1997-04-28','2018-10-20',4000000,20000000,312312313);
insert into tblKhachhang values(11,"Quyên","Bát Tràng","03699647769",0),
								(22,"Tuệ Minh","Hà Nội","0988888888",0),
								(33,"Hưng","Hải Phòng","09877899999",1);

#2.1d
delete from tblMathang
where fsoluong=0;
#2.1e
update tblNhanvien
set fphucap=fphucap*1.1
where year(curdate())-year(dngayvaolam)>=5;
#2.2b
insert into tblDondathang values(1234,1,11,'2018-11-1','2019-10-9',"Hà Bội"),
(6789,1,22,'2019-1-1','2019-3-3',"Hà Nam"),
(3456,2,33,'2019-2-2','2019-5-5',"Bắc Ninh");
#2.2C
insert into tblChitietdathang(isohd,smahang,fsoluongmua) values(1234,"N4010",2),(1234,"N9000",10),(6789,"N10",10),(6789,"110iU",10),(3456,"i3",20),(3456,"i9",30);
update tblChitietdathang,tblmathang
SET tblChiTietDatHang.fGiaban= tblMatHang.fGiahang
WHERE tblMathang.smahang=tblChitietdathang.smahang;
#2.2d
UPDATE tbldondathang,tblchitietdathang
SET fMucgiamgia=fMucgiamgia-(fMucgiamgia*10/100)
WHERE MONTH(dNgaydathang)=7 AND tblChiTietDatHang.iSoHD=tblDonDatHang.iSoHD and year(dNgaydathang)=2016;
#2.2e
delete  from tblchitietdathang
where tblchitietdathang.isohd=1234;
#2.3a
insert into tblDonDatHang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
values(7564,1,33,'2018-5-1','2018-7-1','Hải Phòng'),(10564,2,33,'2019-1-1','2019-3-3','Hải Phòng'),(753364,3,33,'2019-2-2','2019-2-20','Hải Phòng');

INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fSoluongmua,fMucgiamgia)
VALUES(7564,'N4010',5,200000),(7564,'N9000',8,200000),(7564,'110iU',5,500000);
UPDATE tblChiTietDatHang,tblMatHang
SET tblChiTietDatHang.fGiaban=tblMatHang.fGiahang
WHERE tblChiTietDatHang.sMahang=tblMatHang.sMahang;
#2.3b
insert into tblloaihang values("fashion","Thời trang"),("healthcare","healthcare");
#2.3c
INSERT INTO tblMatHang(sMahang,sTenhang,iMaNCC,sMaloaihang,fSoluong,sDonvitinh,fGiahang)
VALUES('BV1','Áo ba lỗ',1,'fashion',2,'dong',200000),('BV2','Giày bata',1,'fashion',2,'dong',900000),('TC2','Áo thun Asus',2,'fashion',3,'dong',600000),('BV21','Áo da bò',2,'fashion',2,'dong',600000),('TC11','Quần đùi',3,'fashion',10,'dong',2000000);
#2.3d
INSERT INTO tblDonDatHang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
VALUES(1102,1,11,'2016-2-2','2016-5-2','Nam Định'),(110032,1,11,'2019-2-2','2019-6-5','Hà Nội');

UPDATE tblChiTietDatHang,tblMatHang
SET tblChiTietDatHang.fGiaban=tblMatHang.fGiahang
WHERE tblChiTietDatHang.sMahang=tblMatHang.sMahang;


INSERT INTO tblChiTietDatHang(iSoHD,sMahang,fSoluongmua,fMucgiamgia)
VALUES(1102,'BV1',6,50000),(1102,'BV2',2,20000),(110032,'TC11',1,50000),(110032,'TC2',6,200000);
#2.3e
update tblChiTietDatHang,tblMatHang,tblDonDatHang
set tblchitietdathang.fgiaban=tblchitietdathang.fgiaban-tblchitietdathang.fgiaban*5/100
WHERE tblChiTietDatHang.sMahang=tblMatHang.sMahang AND tblChiTietDatHang.iSoHD=tblDonDatHang.iSoHD  AND dNgaygiaohang>curdate();
#2.3f
delete from tblloaihang where stenloaihang="healthcare";
#2.4a
INSERT INTO tblKhachHang(iMaKH,sTenKH,sDiaChi,bGioitinh)
VALUES(123,'Vương Duy Cương','Hà Nội',1),(124,'Nguyễn Thị Hồng','Vĩnh Phúc',0),(125,'Mai Thị Lan','Hà Nội',0);

INSERT INTO tblNhanVien(iMaNV,sTenNV,sDiachi,sDienthoai,dNgaysinh,dNgayvaolam,fLuongcoban,fPhucap,sCMND)
VALUES(457,'Bùi Thu Trang','Hà Nội','0147258951','1997-6-6','2017-6-6',300000,100000,'77665544'),
(458,'Bùi Thu Huyền','Hà Nội','0147256951','1997-6-2','2017-6-6',300000,100000,'77664455'),
(459,N'Hà Huy Mạnh',N'Hà Tĩnh','01639238086','2017-10-20','2017-6-6',400000,100000,'14568521');
#2.4b
INSERT INTO tblDonNhapHang(iSoHD,iMaNV,dNgaynhaphang)
VALUES(15,458,'2016-2-2'),(16,459,'2016-3-3'),(17,457,'2017-3-3');
#2.4c
INSERT INTO tblChiTietNhapHang(iSoHD,sMahang,fGianhap,fSoluongnhap)
VALUES(15,'BV1',150000,5),(15,'BV2',5000000,10),(17,'TC11',12000000,20);

INSERT INTO tblChiTietNhapHang(iSoHD,sMahang,fGianhap,fSoluongnhap)
VALUES(16,'BV21',150000,15),(16,'TC2',500000,30),(17,'BV2',12000000,10);
#2.4d
DELETE FROM tblChiTietNhapHang
WHERE iSoHD=15;
