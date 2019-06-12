drop database if exists Quanlibanhang;
create database Quanlibanhang;
use Quanlibanhang;
drop table if exists tblLoaihang;
create table tblLoaihang
(
smaloaihang nvarchar(10) primary key ,
sTenloaihang nvarchar(10) not null

);
drop table if exists tblNhacungcap;
create table tblNhacungcap
(
iMancc int auto_increment primary key,
stennhacC nvarchar(50),
stengiaodich nvarchar(50),
sdiachi nvarchar(50),
sdienthoai nvarchar(12)
);
drop table if exists tblKhachHang;
create table tblKhachHang(
iMaKH int primary key,
sTenKH nvarchar(30),
sDiachi nvarchar(50),
sDienthoai nvarchar(12)
);
drop table if exists tblNhanVien;
create table tblNhanVien(
iMaNV int primary key,
sTenNv nvarchar(30),
sDiachi nvarchar(50),
sDienthoai nvarchar(12),
dNgaysinh datetime,
dNgayvaolam datetime,
fLuongcoban float,
fPhucap float
);
#cau c
use Quanlibanhang;
alter table tblNhanvien
add sCMND int unique;
#cau e
use Quanlibanhang;
alter table tblNhanvien
 add CONSTRAINT  dNgayvaolam
 check (year(dNgayvaolam)-year(dNgaysinh)>=18);
 #cauf
 use Quanlibanhang;
 drop table if exists tblMathang;
 create table tblMathang(
 sMahang nvarchar(10) primary key,
 sTenhang nvarchar(30),
 iMaNCC int,
 sMaloaihang nvarchar(10),
 fSoluong float,
 fGiahang float,
 foreign key (smaloaihang) references tblLoaihang(smaloaihang),
 foreign key (imancc) references tblNhacungcap(imancc)
 );
 
 alter table tblMathang 
 add sDonvitinh nvarchar(10);
 #cau g
 Create index tenhang on tblMathang(stenhang);
 use Quanlibanhang;
drop table if exists tblDonnhaphang;
create table tblDonnhaphang(
iSoHD int primary key ,
iMaNV int,
dNgaynhaphang datetime 
);
drop table if  exists tblChitietnhaphang;
Create table tblChitietnhaphang(
iSoHD int ,
 sMahang nvarchar(10),
fGianhap float,
fsoluongnhap float
);
alter table tblChitietnhaphang 
add primary key(iSoHD,sMahang);
#####
alter table tblDonnhaphang 
add foreign key (iMaNV) references tblNhanVien(iMaNV);
alter table tblChitietnhaphang
add foreign key (sMahang) references tblMathang(sMahang);
alter table tblChitietnhaphang
add foreign key (iSoHD) references tblDonnhaphang(iSoHD);
alter table tblChitietnhaphang 
add constraint check(fgianhap >0 and  fsoluongnhap >0);
use Quanlibanhang;
alter table tblkhachhang
add bGioitinh bit;
use Quanlibanhang;
drop table if exists tblDondathang;
create table tblDondathang(
iSoHD int primary key,
iMaNv int,
iMaKH int,
dNgaydathang Datetime default now() check(dNgaydathang < curdate()),
dNgaygiaohang datetime check (dNgaygiaohang > dNgaydathang),
sDiachigiaohang nvarchar(50)
);
alter table tblDondathang
add foreign key (iMaKH) references tblKhachhang(iMaKH);
alter table tblDondathang
add foreign key (iManv) references tblNhanvien(iManv);
 use quanlibanhang;
drop table if exists tblchitietdathang;
create table tblchitietdathang(
iSohd int,
sMahang nvarchar(20),
fgiaban float,
fSoluongmua float,
fMucgiamgia float
);
alter table tblchitietdathang
modify sMahang nvarchar(10);
alter table tblchitietdathang
add foreign key (sMahang) references tblMathang(sMahang);
alter table tblchitietdathang
add foreign key(iSoHD) references tbldondathang(iSoHd);
alter table tblchitietdathang
add primary key (iSoHD,sMahang);
alter table tblchitietdathang
add constraint check(fgiaban >0 and fsoluongmua >0 and fmucgiamgia >=0);