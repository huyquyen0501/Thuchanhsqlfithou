--Bai tap buoi 6
--                                -- TRAM 1------------------------------------------------------------------
-- Tao LinkedServer Ben May tram 1
-- Tạo LinkedServer
EXEC master.dbo.sp_addlinkedserver
	@server =N'Tram2',
	@srvproduct=N'Sql2K12',
	@provider =N'SQLOLEDB',
	@datasrc =N'10.0.0.5,1433'

--Kiem tra
EXEC sys.sp_linkedservers
--Dang nhap vap LinkedServer
Exec master.dbo.sp_addlinkedsrvlogin	
	@rmtsrvname=N'Tram2',
	@useself=N'False',
	@locallogin =NULL,
	@rmtuser =N'sa',
	@rmtpassword ='123456'

--Chay test
SELECT * FROM Tram2.QLQuanAn.dbo.NhanVien
----------------------------------------------------
--Bai 6.1
--a) Phan tan ngang bang tblKhachHang theo dieu kien kh co dia chi 'Ha Noi' dat tram 1, khong phai 'Ha Noi' thi tram 2
CREATE DATABASE QLBanHang6
GO
USE QLBanHang6
GO
--Tao Bang Khach Hang
CREATE TABLE tblKhachHang
(
	iMaKH INT PRIMARY KEY NOT NULL,
	sTenKH NVARCHAR(30),
	sDiaChi NVARCHAR(50) CHECK (sDiaChi=N'Hà Nội'),
	sDienThoai NVARCHAR(12),
	tuoi INT
)
-- Thu tuc them du lieu va dua vao tram tuong ung
create proc spInserKhachHang(@ma int,@tenKH nvarchar(30),@DiaChi nvarchar(50),@sDienThoai nvarchar(12),@tuoi int)
as
begin
if (@DiaChi = N'Hà Nội')
	insert into QLBanHang6.dbo.tblKhachHang
	        ( iMaKH ,
	          sTenKH ,
	          sDiaChi ,
	          sDienThoai ,
	          tuoi
	        )
	VALUES  ( @ma , -- iMaKH - int
	          @tenKH, -- sTenKH - nvarchar(30)
	          @DiaChi , -- sDiaChi - nvarchar(50)
	          @sDienThoai , -- sDienThoai - nvarchar(12)
	          @tuoi  -- tuoi - int
	        )
else
	insert into Tram2.QLBanHang6.dbo.tblKhachHang
	        ( iMaKH ,
	          sTenKH ,
	          sDiaChi ,
	          sDienThoai ,
	          tuoi
	        )
	VALUES  ( @ma , -- iMaKH - int
	          @tenKH, -- sTenKH - nvarchar(30)
	          @DiaChi , -- sDiaChi - nvarchar(50)
	          @sDienThoai , -- sDienThoai - nvarchar(12)
	          @tuoi  -- tuoi - int
	        )
	print N'Đã thêm Khách Hàng  thành công! '
end


--Thực thi
SELECT * FROM dbo.tblKhachHang
EXEC spInserKhachHang 9,N'Bùi Công Quang',N'Hà Nội',N'09888888',40
EXEC spInserKhachHang 10,N'Đặng Đình Chung',N'Thành Phố Hồ Chí Minh',N'09232323',22
EXEC spInserKhachHang 3,N'Lương Bằng Quang',N'Vinh',N'09232323',31
EXEC spInserKhachHang 4,N'Đặng Đình Chung',N'Nha Trang',N'09222222',24
EXEC spInserKhachHang 5,N'Trần Tâm',N'Thành Phố Hồ Chí Minh',N'04333334',19
EXEC spInserKhachHang 6,N'Trịnh Thị Xuân',N'Hà Nội',N'09666666',25
EXEC spInserKhachHang 7,N'aaaa',N'Hà Nội',N'09888888',40
EXEC spInserKhachHang 8,N'bb',N'Vinh',N'09888888',41

--test tram 1: Khach hang o ha noi
SELECT * FROM dbo.tblKhachHang
--test tram 2: khach hang khong o ha noi
SELECT * FROM Tram2.QLBanHang6.dbo.tblKhachHang

-- Ket nối 2 bảng để lấy dữ liệu gốc
SELECT * FROM dbo.tblKhachHang
union
SELECT * FROM Tram2.QLBanHang6.dbo.tblKhachHang

--6.1 b)
SELECT * FROM dbo.tblKhachHang where tuoi>=18 AND tuoi <=25
UNION
SELECT * FROM Tram2.QLBanHang6.dbo.tblKhachHang WHERE  sDiaChi=N'Thành Phố Hồ Chí Minh' AND tuoi>=18 AND tuoi <=25
DELETE dbo.tblKhachHang WHERE iMaKH=6

-----------------------------------------------------------------------------------
--6.2 
--a) Phan tan ngang bang tblNhanVien theo dieu kien nhan vien co luong co ban duoi 4tr dat tai tram 1 va cac nhan vien
--con lai dat tai tram 2
--Tao bang nhan vien
CREATE TABLE tblNhanVien
(
	iMaNV INT PRIMARY KEY NOT NULL,
	sTenNV NVARCHAR(30),
	sDiaChi NVARCHAR(50),
	sDienThoai NVARCHAR(12),
	dNgaySinh DATE,
	dNgayVaoLam DATE,
	fLuongcoban FLOAT CHECK (fLuongcoban<4),
	fPhuCap FLOAT
)

--b)
create proc spInsertNhanVien(@ma int,@tenNV nvarchar(30),@DiaChi nvarchar(50),@sDienThoai nvarchar(12),@NgaySinh date,@NgayVaoLam date,
@Luongcoban float,@PhuCap float)
as
begin
if (@Luongcoban< 4)
	INSERT INTO dbo.tblNhanVien
	        ( iMaNV ,
	          sTenNV ,
	          sDiaChi ,
	          sDienThoai ,
	          dNgaySinh ,
	          dNgayVaoLam ,
	          fLuongcoban ,
	          fPhuCap
	        )
	VALUES  ( @ma , -- iMaNV - int
	          @tenNV , -- sTenNV - nvarchar(30)
	          @DiaChi , -- sDiaChi - nvarchar(50)
	          @sDienThoai , -- sDienThoai - nvarchar(12)
	          @NgaySinh , -- dNgaySinh - date
	          @NgayVaoLam , -- dNgayVaoLam - date
	          @Luongcoban , -- fLuongcoban - float
	          @PhuCap  -- fPhuCap - float
	        )
ELSE 
INSERT INTO Tram2.QLBanHang6.dbo.tblNhanVien
        ( iMaNV ,
          sTenNV ,
          sDiaChi ,
          sDienThoai ,
          dNgaySinh ,
          dNgayVaoLam ,
          fLuongcoban ,
          fPhuCap
        )
	VALUES  ( @ma , -- iMaNV - int
	          @tenNV , -- sTenNV - nvarchar(30)
	          @DiaChi , -- sDiaChi - nvarchar(50)
	          @sDienThoai , -- sDienThoai - nvarchar(12)
	          @NgaySinh , -- dNgaySinh - date
	          @NgayVaoLam , -- dNgayVaoLam - date
	          @Luongcoban , -- fLuongcoban - float
	          @PhuCap  -- fPhuCap - float
	        )
print N'Đã thêm nhân viên thành công! '
END

-- Test Them
EXEC spInsertNhanVien 1,N'NGuyễn Văn A',N'Hà Nội',N'23456','1998-02-02','2012-04-04',4,2
EXEC spInsertNhanVien 2,N'Trịnh Thuy B',N'Ninh Bình',N'5345345','1999-04-02','2015-03-06',1.2,5
EXEC spInsertNhanVien 3,N'Bùi Văn C',N'Thanh Hóa',N'3498433','2000-04-09','2017-04-12',2.5,3
EXEC spInsertNhanVien 4,N'Ninh Van Cao',N'Hà Nội',N'23456','1998-02-02','2012-04-04',3,2
EXEC spInsertNhanVien 5,N'Ninh Van Thap',N'Hà Nội',N'23456','1998-02-02','2012-04-04',10,2

--test tram 1: nhung  nhan vien co luong co ban duoi 4tr
SELECT * FROM dbo.tblNhanVien
--test tram 2: nhung nhan vien co luong co ban >=4tr
SELECT * FROM Tram2.QLBanHang6.dbo.tblNhanVien

--c)Tạo View ds Nhan vien làm việc trên 2 năm

CREATE VIEW vwNV2Nam
AS
SELECT *FROM dbo.tblNhanVien WHERE YEAR(GETDATE())-YEAR(dNgayVaoLam)>2
UNION
SELECT * FROM Tram2.QLBanHang6.dbo.tblNhanVien WHERE YEAR(GETDATE())-YEAR(dNgayVaoLam)>2

-- Chay view
SELECT * FROM vwNV2Nam

-----------------------------------------------------------------------------------------
--6.3
--a) Chia tach doc tren tblDonDatHang thanh 2 bang theo cau truc
--tblThongTinGiaoHang (iSoHD,dNgayGiaoHang,sDiachigiaohang)
--tblDonDatHang(iSohd,iMaNV,iMaKH,DngayDatHang)

--Tao tblDonDatHang o Tram 1
CREATE TABLE tblDonDatHang
(
	iSoHD INT PRIMARY KEY NOT NULL,
	iMaNV INT,
	iMaKH INT,
	dNgayDatHang DATETIME,
)
ALTER TABLE dbo.tblDonDatHang ADD CONSTRAINT FK_NV FOREIGN KEY(iMaNV) REFERENCES dbo.tblNhanVien(iMaNV)
ALTER TABLE dbo.tblDonDatHang ADD CONSTRAINT FK_KH FOREIGN KEY(iMaKH) REFERENCES dbo.tblKhachHang(iMaKH)


-- Procedure test 
create proc spInsertDonDatHang(@SoHD int,@MaNV INT,@MaKH int,@NgayDatHang datetime,@NgayGiaoHang datetime,@DiaChiGiaoHang nvarchar(50))
 as
 begin 
	insert into QLBanHang6.dbo.tblDonDatHang
	        ( iSoHD, iMaNV, iMaKH, dNgayDatHang )
	VALUES  ( @SoHD, -- iSoHD - int
	          @MaNV, -- iMaNV - int
	          @MaKH, -- iMaKH - int
	          @NgayDatHang -- dNgayDatHang - datetime
	          )
	insert into Tram2.QLBanHang6.dbo.tblThongTinGiaoHang
	VALUES (@SoHD,@NgayGiaoHang,@DiaChiGiaoHang)
	print N'Thêm Đơn Đặt Hàng Thành Công!'
end

-- Test :
EXEC spInsertDonDatHang 6,2,1,'2004-03-04','2005-04-03',N'Vũng Tàu'
EXEC spInsertDonDatHang 5,3,1,'2014-03-25','2015-04-09',N'Hà Nội'
EXEC spInsertDonDatHang 3,4,7,'2017-03-25','2018-04-09',N'Hue'
EXEC spInsertDonDatHang 4,4,7,'2017-03-25','2018-04-09',N'Hue'
--xoa
DELETE dbo.tblDonDatHang
--test
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblKhachHang

SELECT * FROM dbo.tblDonDatHang
SELECT * FROM Tram2.QLBanHang6.dbo.tblThongTinGiaoHang
--xoa
DELETE Tram2.QLBanHang6.dbo.tblThongTinGiaoHang




--d) 

-- Lay du lieu 2 bang (thongtingiaohang va dondathang) ra Bang DONDATHANG Ban đầu ---- >> Tao thanh 1 view
CREATE VIEW vwDonDatHang
AS
SELECT a.iSoHD,a.iMaNV,a.dNgayDatHang,b.dNgayGiaoHang 
FROM dbo.tblDonDatHang a,Tram2.QLBanHang6.dbo.tblThongTinGiaoHang b
WHERE a.iSoHD = b.iSoHD

--xem View
SELECT * FROM vwDonDatHang


-- test
SELECT COUNT(a.iMaNV) AS TongSoHD,a.iMaNV,a.dNgayDatHang,b.dNgayGiaoHang
FROM dbo.tblDonDatHang a,Tram2.QLBanHang6.dbo.tblThongTinGiaoHang b
WHERE a.iSoHD = b.iSoHD
--WHERE (GETDATE()-vwNV2Nam.dNgayDatHang)<0
GROUP BY a.iMaNV

------------------------------------
-- Tao 1 view lay thong tin nhan vien 2 tram
CREATE VIEW vwNV2tram
AS
SELECT * FROM dbo.tblNhanVien
UNION
SELECT * FROM Tram2.QLBanHang6.dbo.tblNhanVien
--
SELECT * FROM vwNV2Tram

alter VIEW vw_NvGiaoHang
as
SELECT a.iMaNV,c.sTenNV,COUNT(a.iSoHD) AS TongSoHD_ChuaGiao
FROM dbo.tblDonDatHang a,Tram2.QLBanHang6.dbo.tblThongTinGiaoHang b,vwNV2tram c
WHERE a.iSoHD = b.iSoHD AND (b.dNgayGiaoHang- GETDATE())>0 AND a.dNgayDatHang<>0 AND c.iMaNV = a.iMaNV
GROUP BY a.iMaNV,c.sTenNV


SELECT * FROM vw_NVGiaoHang

SELECT * FROM dbo.tblNhanVien
SELECT GETDATE()-'2014-02-02'


SELECT * FROM Tram2.QLBanHang6.dbo.tblKhachHang


SELECT 
FROM dbo.tblNhanVien,dbo.tblDonDatHang


SELECT * FROM dbo.tblNhanVien
UNION
SELECT * FROM Tram2.QLBanHang6.dbo.tblNhanVien


--------------------------------------------------------------------------------------------------------
---------------------------------------- Tram 2 Tao linked Server--------------------------
exec master.dbo.sp_addlinkedserver 
@server =N'Tram1',
@srvproduct=N'SQL2k12',
@provider=N'SQLOLEDB',
@datasrc=N'10.0.0.3,1433'

exec master.dbo.sp_addlinkedsrvlogin
@rmtsrvname =N'Tram1',
@useself=N'False',
@locallogin=null,
@rmtuser=N'sa',
@rmtpassword='chau123'


-- Tram 2 tao database va cac table : tao may ben kia
create database QLBanHang6
use QLBanHang6
create table tblKhachHang
(
	iMaKH int primary key not null,
	sTenKH nvarchar(30),
	sDiaChi nvarchar(50) check(sDiaChi<>N'Hà Nội'),
	sDienThoai nvarchar(12),
	tuoi int
)
select * from QLBanHang6.dbo.tblKhachHang


-- Tram 2 Tao table Nhan Vien
create table tblNhanVien
(
	iMaNV int primary key not null,
	sTenNV nvarchar(30),
	sDiaChi nvarchar(50),
	sDienThoai nvarchar(12),
	dNgaySinh date,
	dNgayVaoLam date,
	fLuongcoban float check (fLuongcoban >=4),
	fPhuCap float
)

select * from QLBanHang6.dbo.tblNhanVien


--Tao Table Thong tin giao hang
create table tblThongtinGiaoHang
(
	iSoHD int primary key not null,
	dNgayGiaoHang datetime,
	sDiaChiGiaoHang nvarchar(50)
)
delete tblThongtinGiaoHang

select * from tblThongtinGiaoHang
select * from tram1.QLBanHang6.dbo.tblNhanVien


select * 
from tblThongtinGiaoHang a,tram1.QLBanHang6.dbo.tblDonDatHang b
where a.iSoHD=b.iSoHD

--b)
SELECT * FROM tblDonDatHang a, tram2.QLbanhang6.dbo.tblThongtinGiaoHang b
WHERE a.isoHD = b.iSoHD
