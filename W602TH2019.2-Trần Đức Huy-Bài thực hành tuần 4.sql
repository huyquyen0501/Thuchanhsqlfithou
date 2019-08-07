USE ThucHanhBanHangFULL
GO


SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang

CREATE PROC sp_mathangkhongbanduoc
@nam int
AS
SELECT sMahang,sTenhang
 FROM dbo.tblMatHang
 WHERE sMahang NOT IN ( SELECT dbo.tblChiTietDatHang.sMahang
 FROM dbo.tblMatHang,dbo.tblDonDatHang,dbo.tblChiTietDatHang
 WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD AND dbo.tblMatHang.sMahang = dbo.tblChiTietDatHang.sMahang
 AND YEAR(dNgaydathang) = @nam)


 
 EXECUTE sp_mathangkhongbanduoc @nam = 2016

SELECT * FROM dbo.tblNhanVien
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang


CREATE VIEW a
AS
SELECT dbo.tblDonDatHang.iMaNV,sTenNV,SUM(fSoluongmua) AS Tong_SL
FROM dbo.tblNhanVien,dbo.tblDonDatHang,dbo.tblChiTietDatHang
WHERE dbo.tblNhanVien.iMaNV = dbo.tblDonDatHang.iMaNV AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
GROUP BY dbo.tblDonDatHang.iMaNV,sTenNV

SELECT * FROM a
DROP VIEW a



CREATE PROC sp_tangluongnv
@slhang float,
@nam int
AS
UPDATE dbo.tblNhanVien
SET fLuongcoban = fLuongcoban * 1.5
FROM a, dbo.tblDonDatHang
WHERE a.iMaNV = dbo.tblNhanVien.iMaNV AND dbo.tblDonDatHang.iMaNV = dbo.tblNhanVien.iMaNV AND YEAR(dNgaydathang) = @nam
AND a.Tong_SL > @slhang

DROP PROC sp_tangluongnv

EXECUTE sp_tangluongnv 10,2016


SELECT dbo.tblNhanVien.iMaNV,sTenNV,fLuongcoban, SUM(fSoluongmua) AS Tong_SLBAN
FROM dbo.tblNhanVien,dbo.tblDonDatHang,dbo.tblChiTietDatHang
WHERE dbo.tblNhanVien.iMaNV = dbo.tblDonDatHang.iMaNV AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
GROUP BY dbo.tblNhanVien.iMaNV,sTenNV,fLuongcoban




SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblChiTietDatHang

CREATE PROC sp_thongkeSL
@ma nvarchar(10)
AS
SELECT dbo.tblChiTietDatHang.sMahang,sTenhang, SUM(fSoluongmua) AS Tong_SLBan 
FROM dbo.tblMatHang,dbo.tblChiTietDatHang
WHERE dbo.tblMatHang.sMahang = dbo.tblChiTietDatHang.sMahang AND dbo.tblChiTietDatHang.sMahang = @ma
GROUP BY dbo.tblChiTietDatHang.sMahang,sTenhang

DROP PROC sp_thongkeSL
EXECUTE sp_thongkeSL @ma = N'10'


SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang

CREATE PROC sp_TThangthuduoctrongnam
@nam int
AS
SELECT YEAR(dNgaydathang) AS Năm, SUM(fSoluongmua*fGiaban) AS Tổng_Tiền
FROM dbo.tblMatHang,dbo.tblDonDatHang,dbo.tblChiTietDatHang
WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD AND dbo.tblMatHang.sMahang = dbo.tblChiTietDatHang.sMahang
AND YEAR(dNgaydathang) = @nam
GROUP BY YEAR(dNgaydathang)

DROP PROC sp_TThangthuduoctrongnam

EXECUTE sp_TThangthuduoctrongnam @nam = 2015


SELECT * FROM dbo.tblChiTietDatHang

CREATE TRIGGER Check_giaban
ON dbo.tblChiTietDatHang
after INSERT,UPDATE
AS 
begin
DECLARE @Giaban FLOAT,@Mahang NVARCHAR(10),@Giahang float
SELECT @Giaban = fGiaBan,@Mahang = sMahang FROM inserted
SELECT @Giahang(SELECT fGiahang
FROM dbo.tblMatHang
WHERE dbo.tblMatHang.sMahang=@Mahang)
IF(@Mahang NOT IN (SELECT sMahang FROM dbo.tblMatHang))
BEGIN
	PRINT N'Mã hàng không tồn tại ! '
	ROLLBACK TRAN
END
ELSE 
IF(@Giaban<@Giahang)
BEGIN
	PRINT N'Gia bán phải lớn hơn hoặc bằng giá hàng!'
	ROLLBACK TRAN
END
END
DROP TRIGGER check_giaban

ALTER TABLE dbo.tblChiTietDatHang ENABLE TRIGGER check_giaban
SELECT * FROM dbo.tblMatHang

DELETE dbo.tblChiTietDatHang WHERE iSoHD = 2


--VD:
INSERT INTO dbo.tblChiTietDatHang
        ( iSoHD ,
          sMahang ,
          fGiaban ,
          fSoluongmua ,
          fMucgiamgia
        )
VALUES  ( 2 ,
          N'3' , 
          3000.0 ,
          20.0 , 
          0.0  
        )

UPDATE dbo.tblChiTietDatHang
SET fGiaban =1
WHERE iSoHD = 100 AND sMahang = N'10'



SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang

CREATE TRIGGER check_giahang
ON dbo.tblChiTietDatHang
AFTER INSERT,UPDATE
AS
DECLARE @slban FLOAT, @MaHang NVARCHAR(20),@Soluong FLOAT
SELECT @slban = fSoluongmua, @MaHang=sMahang FROM inserted
SELECT @Soluong = (SELECT fSoluong FROM dbo.tblMatHang WHERE sMahang=@MaHang)
IF(@slban>@Soluong)
BEGIN
	PRINT N'Số lượng bán phải nhỏ hơn hoặc bằng số lượng trong kho'
	ROLLBACK TRAN
END

DROP TRIGGER check_giahang


DELETE dbo.tblChiTietDatHang WHERE iSoHD = 2

SELECT * FROM dbo.tblChiTietDatHang
INSERT INTO dbo.tblChiTietDatHang
        ( iSoHD ,
          sMahang ,
          fGiaban ,
          fSoluongmua ,
          fMucgiamgia
        )
VALUES  ( 2 , 
          N'3' , 
          1 , 
          9999999 , 
          2.0  
        ) 


UPDATE dbo.tblChiTietDatHang
SET fSoluongmua = 99999999 
WHERE  iSoHD = 2 AND sMahang = N'3'





SELECT * FROM dbo.tblDonDatHang
DROP PROC sp_Themdondathang
CREATE PROC sp_Themdondathang
@iSoHD int, @iMaNV int, @iMaKH int, @dNgayDatHang datetime, @dNgayGiaoHang datetime, @sdiachigiaohang nvarchar(50) 
AS
IF (@dNgayDatHang <= GETDATE() AND @dNgayGiaoHang >= @dNgayDatHang)
BEGIN 
INSERT INTO dbo.tblDonDatHang
        ( iSoHD ,
          iMaNV ,
          iMaKH ,
          dNgaydathang ,
          dNgaygiaohang ,
          sDiachigiaohang
        )
VALUES  ( @iSoHD ,
          @iMaNV , 
          @iMaKH , 
          @dNgayDatHang ,
          @dNgayGiaoHang , 
          @sdiachigiaohang  
        )
END
ELSE PRINT N'Du lieu nhap vao la sai'

EXECUTE sp_Themdondathang 20,1,3,'2017-3-4','2017-3-1',N'Hà Nội'


SELECT * FROM dbo.tblKhachHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang

ALTER TABLE dbo.tblKhachHang ADD TongTienHang FLOAT 
GO

CREATE TRIGGER TG_tongtienhang
ON dbo.tblChiTietDatHang
AFTER INSERT
AS
DECLARE @sohd int, @makh int, @tienhang float
SELECT @sohd = iSoHD FROM inserted
SELECT @makh = (SELECT iMaKH FROM dbo.tblDonDatHang WHERE iSoHD = @sohd)
SELECT @tienhang = (SELECT SUM(fGiaban*fSoluongmua) AS tongtienhang
 FROM dbo.tblKhachHang,dbo.tblDonDatHang,dbo.tblChiTietDatHang
 WHERE dbo.tblKhachHang.iMaKH = dbo.tblDonDatHang.iMaKH AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
 AND dbo.tblChiTietDatHang.iSoHD = @sohd
 GROUP BY dbo.tblChiTietDatHang.iSoHD)
 IF not exists (select iMaKH from dbo.tblDonDatHang where iMaKH=@MaKH)
	begin
		print N'Khách hàng chưa đặt hàng!'
		rollback tran
			end
IF((SELECT TongTienHang FROM dbo.tblKhachHang WHERE iMaKH = @MaKH)=NULL) 
BEGIN
	UPDATE dbo.tblKhachHang SET TongTienHang = 0 WHERE iMaKH = @MaKH
END
UPDATE dbo.tblKhachHang
SET TongTienHang =  @TienHang
WHERE dbo.tblKhachHang.iMaKH=@MaKH
-------------------------------------------------------
UPDATE dbo.tblKhachHang
SET TongTienHang = 0
DELETE dbo.tblChiTietDatHang WHERE iSoHD = 2
SELECT * FROM dbo.tblKhachHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
DROP TRIGGER TG_TongTienHang

INSERT INTO dbo.tblChiTietDatHang
        ( iSoHD ,
          sMahang ,
          fGiaban ,
          fSoluongmua ,
          fMucgiamgia
        )
VALUES  ( 2 , 
          N'B1' ,
          10.0 ,
          5.0 , 
          12121.0 
        )


SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblNhaCungCap
SELECT * FROM dbo.tblDonNhapHang
SELECT * FROM dbo.tblChiTietNhapHang


CREATE PROC sp_tenmh
@tennhacc nvarchar(50),
@nam int
AS
SELECT sTenhang,sTenNhaCC,dbo.tblMatHang.sMahang 
FROM dbo.tblMatHang,dbo.tblNhaCungCap,dbo.tblDonNhapHang,dbo.tblChiTietNhapHang
WHERE dbo.tblMatHang.iMaNCC = dbo.tblNhaCungCap.iMaNCC AND dbo.tblChiTietNhapHang.sMahang = dbo.tblMatHang.sMahang
AND dbo.tblDonNhapHang.iSoHD = dbo.tblChiTietNhapHang.iSoHD AND YEAR(dNgaynhaphang) = @nam AND sTenNhaCC = @tennhacc

DROP PROC sp_tenmh
--Kich hoat
EXECUTE sp_tenmh N'Bảo Trọng',2018

--theo tên mặt hàng(tham số truyền vào là tên mặt hàng)
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblNhaCungCap
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietNhapHang

DROP PROC sp_caud

CREATE PROC sp_caud
@tenmathang nvarchar(30)
AS
SELECT sTenNhaCC,dNgaynhaphang 
FROM dbo.tblMatHang,dbo.tblNhaCungCap,dbo.tblDonNhapHang,dbo.tblChiTietNhapHang
WHERE dbo.tblMatHang.sMahang = dbo.tblChiTietNhapHang.sMahang AND dbo.tblMatHang.iMaNCC = dbo.tblNhaCungCap.iMaNCC
AND dbo.tblDonNhapHang.iSoHD = dbo.tblChiTietNhapHang.iSoHD AND @tenmathang = sTenhang

EXECUTE sp_caud N'Phim ma'


SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
ALTER TABLE dbo.tblDonDatHang ADD tongsomathang FLOAT 


CREATE TRIGGER tg_tongsomathang
ON dbo.tblChiTietDatHang
AFTER INSERT
as
DECLARE @SoHD INT ,@Mahang NVARCHAR(10),@TongMatHang float
SELECT @SoHD = iSoHD,@Mahang = sMahang FROM inserted 
SELECT @TongMatHang = fSoluongmua FROM inserted
SELECT @TongMatHang = (SELECT COUNT(dbo.tblChiTietDatHang.sMahang)
FROM dbo.tblChiTietDatHang
WHERE dbo.tblChiTietDatHang.iSoHD = @SoHD
GROUP BY iSoHD)
UPDATE dbo.tblDonDatHang
SET TongSoMatHang =0 + @TongMatHang
WHERE iSoHD = @SoHD

UPDATE dbo.tblDonDatHang 
SET tongsomathang=0

DROP TRIGGER tg_tongsomathang


SELECT * FROM dbo.tblDonDatHang


INSERT INTO dbo.tblChiTietDatHang
        ( iSoHD ,
          sMahang ,
          fGiaban ,
          fSoluongmua ,
          fMucgiamgia
        )
VALUES  ( 2 ,
          N'3' ,
          2.0 , 
          1.0 ,
          1.0  
        )
		DELETE dbo.tblChiTietDatHang WHERE iSoHD = 2

SELECT  sMaloaihang FROM dbo.tblLoaiHang
SELECT  iMaNCC FROM dbo.tblNhaCungCap
SELECT sMaloaihang FROM dbo.tblLoaiHang


SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblDonDatHang


--4.3)

SELECT * FROM dbo.tblMatHang
CREATE PROC sp_addmathang
@mahang nvarchar(10),
@tenhang nvarchar(30),
@manhacc int,
@maloaihang nvarchar(10),
@fsoluong float,
@fgiahang float,
@donvitinh nvarchar(10)
AS

INSERT INTO dbo.tblMatHang
        ( sMahang ,
          sTenhang ,
          iMaNCC ,
          sMaloaihang ,
          fSoluong ,
          fGiaHang ,
          sDonvitinh
        )
VALUES  ( @mahang , 
          @tenhang , 
         @manhacc , 
         @maloaihang , 
          @fsoluong , 
          @fgiahang , 
          @donvitinh  
        )


EXECUTE sp_addmathang 03,N'cc',1,A1,12,3,N'VNĐ'


SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang

CREATE PROC sp_giamgia
@giatri float,
@mucgiamgia float
AS
UPDATE dbo.tblChiTietDatHang
SET fMucgiamgia = @mucgiamgia
FROM dbo.tblDonDatHang
WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
AND YEAR(dbo.tblDonDatHang.dNgaydathang) = YEAR(GETDATE())
AND MONTH(dbo.tblDonDatHang.dNgaydathang) = MONTH(GETDATE())
AND fMucgiamgia = 0 AND (fGiaban*fSoluongmua)>=@giatri


EXECUTE sp_giamgia 19000,1





ALTER PROC sp_insert
	@chuoi nvarchar(256),
	@sMahang nvarchar(10)=null, @iSoHD int , @fGiaban float =null, @fSoluongmua int = null, @fMucgiamgia float=0,
	@iMaNV int, @iMaKH int, @dNgaygiaohang nvarchar(20), @dNgaydathang nvarchar(20), @sDiachigiaohang nvarchar(20)
	AS
	BEGIN
		WHILE LEN(@chuoi) <> 0
		BEGIN
		SET @sMahang = SUBSTRING(@chuoi , 1 , CHARINDEX(',', @chuoi)-1)
		SET @chuoi = SUBSTRING(@chuoi ,CHARINDEX(',', @chuoi)+1, LEN(@chuoi))
			IF CHARINDEX(',', @chuoi) = 0
				BEGIN
					SET @fSoluongmua = SUBSTRING(@chuoi , 1 , LEN(@chuoi))
					SET @chuoi = ''
					SET @fGiaban = (SELECT fGiahang FROM tbl_MatHang WHERE sMahang = @sMahang)
				END
			ELSE
			BEGIN
				SET @fSoluongmua = SUBSTRING(@chuoi , 1 , CHARINDEX(',', @chuoi)-1)
				SET @chuoi = SUBSTRING(@chuoi ,CHARINDEX(',', @chuoi)+1, LEN(@chuoi))
				SET @fGiaban = (SELECT fGiahang FROM tbl_MatHang WHERE sMahang = @sMahang)
				
			END
			INSERT INTO tbl_DonDatHang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
			VALUES(@iSoHD,@iMaNV,@iMaKH,@dNgaydathang,@dNgaygiaohang,@sDiachigiaohang)
			INSERT INTO tbl_ChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
			VALUES(@iSoHD,@sMahang,@fGiaban,@fSoluongmua,@fMucgiamgia)
			SET @iSoHD = @iSoHD +1
		END
	END
	

EXEC sp_insert @chuoi = 'MH2,6,MH4,10', @iSoHD =13 ,
	@iMaNV=1, @iMaKH =2, @dNgaydathang =N'2017-02-11',@dNgaygiaohang =N'2017-05-15', @sDiachigiaohang= N'Hà Nội'




SELECT CHARINDEX(',','MH1,2,MH2,4,MH3,10')

select substring('abcdefgh',2,5)  

select charindex('abc','cabcaaaa',2)  

Drop trigger tg_DropNhanVien;
CREATE trigger tg_DropNhanVien
ON tblNhanVien
after insert
as 
begin
	DECLARE @MaNVXoa int,
			@MaNVNhap int,
			@MaNVXuat int,
			@SoHDNVXNhap int,
			@SoHDNVXXuat int,
			@SoHDNVKNhap int,
			@SoHDNVKXuat int
	select @MaNVXoa = (select iMaNV from inserted)
	
	select @SoHDNVXNhap = (select count(iSoHD)  from tbl_DonDatHang where tbl_DonDatHang.iMaNV = @MaNVXoa)
	select @SoHDNVXXuat = (select count(iSoHD)  from tbl_DonNhapHang where tbl_DonNhapHang.iMaNV = @MaNVXoa)
	
	select @SoHDNVKNhap = (select TOP 1 count(iSoHD) from tbl_DonDatHang having count(iSoHD) < @SoHDNVXNhap)
	select @SoHDNVKXuat = (select TOP 1 count(iSoHD)  from tbl_DonNhapHang having count(iSoHD) < @SoHDNVXXuat)
	
	select @MaNVNhap = (select iMaNV from tbl_DonDatHang where tbl_DonDatHang.iSoHD = @SoHDNVKNhap )
	select @MaNVXuat = (select iMaNV from tbl_DonNhapHang where tbl_DonNhapHang.iSoHD = @SoHDNVKXuat )
	
	Update tbl_DonDatHang set iMaNV = @MaNVNhap where iMaNV = @MaNVXoa
	Update tbl_DonNhaptHang set iMaNV = @MaNVXuat where iMaNV = @MaNVXoa
end

select* from tblNhanVien
select* from tblDonDatHang
select  COUNT(iSoHD),iMaNV from tblDonDatHang group by iMaNV having COUNT(iSoHD) < 8

delete from tblNhanVien where iMaNV = 2

									 