USE ThucHanhBanHangFULL
GO

--Thực hành Buổi 3
--Bài 3.1)
-- a) Cho biết những mặt hàng nào có số lượng dưới 100(tblMatHang)
SELECT * FROM dbo.tblMatHang

SELECT sMahang,sTenhang,fSoluong
FROM dbo.tblMatHang
WHERE fSoluong < 100

--b) Tạo view số mặt hàng của từng loại hàng
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblLoaiHang
SELECT * FROM view_TongSoMatHang;

CREATE VIEW view_TongSoMatHang
AS
SELECT dbo.tblMatHang.sMaloaihang,SUM(fsoluong) AS Tổngsốlượng
FROM dbo.tblMatHang,dbo.tblLoaiHang
WHERE dbo.tblMatHang.sMaloaihang=tblLoaiHang.sMaloaihang
GROUP BY dbo.tblMatHang.sMaloaihang

-- c) Cho biết số tiền phải trả của từng đơn đặt hàng
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang

SELECT dbo.tblChiTietDatHang.iSoHD,SUM((fgiaban * fSoluongmua) - fMucgiamgia) AS Tổng_Số_Tiền
FROM dbo.tblDonDatHang INNER JOIN dbo.tblChiTietDatHang
ON dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
GROUP BY dbo.tblChiTietDatHang.iSoHD

--d) Cho biết tổng số tiền hàng thu được trong mỗi tháng của năm 2016(tính theo ngày đặt hàng)
SELECT MONTH(dbo.tblDonDatHang.dNgaydathang) AS Tháng, SUM((fgiaban * fSoluongmua) - fMucgiamgia) AS Tổng_tiền
FROM dbo.tblDonDatHang JOIN dbo.tblChiTietDatHang
ON dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
WHERE YEAR(dNgaydathang) = 2016
GROUP BY dbo.tblDonDatHang.dNgaydathang

--e) Trong năm 2016, những mặt hàng nào chỉ được đặt mua đúng 1 lần
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang

SELECT dbo.tblMatHang.sMahang,dbo.tblMatHang.sTenhang, COUNT(dbo.tblChiTietDatHang.sMahang) AS Số_Lần
FROM dbo.tblDonDatHang,dbo.tblChiTietDatHang,dbo.tblMatHang
WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD 
AND dbo.tblMatHang.sMahang = dbo.tblChiTietDatHang.sMahang 
AND YEAR(dbo.tblDonDatHang.dNgaydathang) = 2016
GROUP BY dbo.tblMatHang.sMahang,dbo.tblMatHang.sTenhang
HAVING COUNT(dbo.tblChiTietDatHang.sMahang) =1
--Bài 3.2) 
--a) Tạo View tính tổng tiền hàng và tổng số mặt hàng của từng đơn nhập hàng
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM view_tongtienvstongmathang
CREATE VIEW view_tongtienvstongmathang
AS
SELECT dbo.tblChiTietDatHang.iSoHD , SUM(fGiaban * fSoluongmua)  AS Tổng_Tiền_Hàng, COUNT(dbo.tblChiTietDatHang.iSoHD) AS Tổng_Số_Mặt_Hàng
FROM dbo.tblDonDatHang,dbo.tblChiTietDatHang,dbo.tblMatHang
WHERE dbo.tblChiTietDatHang.iSoHD = dbo.tblDonDatHang.iSoHD AND dbo.tblChiTietDatHang.sMahang = dbo.tblMatHang.sMahang
GROUP BY dbo.tblChiTietDatHang.iSoHD 

--Test thử :
SELECT * FROM dbo.tblDonDatHang,dbo.tblChiTietDatHang,dbo.tblMatHang
WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD AND dbo.tblChiTietDatHang.sMahang = dbo.tblMatHang.sMahang
INSERT INTO dbo.tblChiTietDatHang
        ( iSoHD ,
          sMahang ,
          fGiaban ,
          fSoluongmua ,
          fMucgiamgia
        )
VALUES  ( 1 , -- iSoHD - int
          N'B4' , -- sMahang - nvarchar(10)
          20400.0 , -- fGiaban - float
          10.0 , -- fSoluongmua - float
          2.0  -- fMucgiamgia - float
        )
--b) Cho biết danh sách tên các mặt hàng mà không được nhập về trong tháng 6 năm 2017
SELECT * FROM dbo.tblDonNhapHang
SELECT * FROM dbo.tblChiTietNhapHang
SELECT * FROM dbo.tblMatHang
--3 bản ghi cua don nhap hang
INSERT INTO dbo.tblDonnhaphang
        ( iSoHD, iMaNV, dNgaynhaphang )
VALUES  ( 103, -- iSoHD - int
          02, -- iMaNV - int
          '2018-06-20'  -- dNgaynhaphang - datetime
          )
INSERT INTO dbo.tblDonnhaphang
        ( iSoHD, iMaNV, dNgaynhaphang )
VALUES  ( 104, -- iSoHD - int
          03, -- iMaNV - int
          '2017-06-12'  -- dNgaynhaphang - datetime
          )
INSERT INTO dbo.tblDonnhaphang
        ( iSoHD, iMaNV, dNgaynhaphang )
VALUES  ( 105, -- iSoHD - int
          04, -- iMaNV - int
          '2018-07-11'  -- dNgaynhaphang - datetime
          )
--3 bản ghi cua chi tiet nhap hang
INSERT INTO dbo.tblChiTietNhapHang
        ( iSoHD ,
          sMahang ,
          fGianhap ,
          fSoluongnhap
        )
VALUES  ( 103 , -- iSoHD - int
          N'B5' , -- sMahang - nvarchar(10)
          20020.0 , -- fGianhap - float
          10.89  -- fSoluongnhap - float
        )
INSERT INTO dbo.tblChiTietNhapHang
        ( iSoHD ,
          sMahang ,
          fGianhap ,
          fSoluongnhap
        )
VALUES  ( 104 , -- iSoHD - int
          N'B4' , -- sMahang - nvarchar(10)
          21420.0 , -- fGianhap - float
          11.89  -- fSoluongnhap - float
        )
INSERT INTO dbo.tblChiTietNhapHang
        ( iSoHD ,
          sMahang ,
          fGianhap ,
          fSoluongnhap
        )
VALUES  ( 105 , -- iSoHD - int
          N'B2' , -- sMahang - nvarchar(10)
          70020.0 , -- fGianhap - float
          19.89  -- fSoluongnhap - float
        )
SELECT dbo.tblMatHang.sMahang,dbo.tblMatHang.sTenhang,dbo.tblDonNhapHang.dNgaynhaphang
FROM dbo.tblDonNhapHang,dbo.tblChiTietNhapHang,dbo.tblMatHang
WHERE dbo.tblMatHang.sMahang = dbo.tblChiTietNhapHang.sMahang AND dbo.tblChiTietNhapHang.iSoHD = dbo.tblDonNhapHang.iSoHD
AND dbo.tblChiTietNhapHang.iSoHD NOT in
SELECT iSoHD
FROM dbo.tblDonNhapHang
WHERE YEAR(dNgaynhaphang) =2017 AND MONTH (dNgaynhaphang)=6
AND YEAR(dNgaynhaphang)!=2017 or MONTH(dNgaynhaphang)!=6


--c) Cho biết tên nhà cung cấp đã cung cấp những mặt hàng thuộc 1 loại hàng xác định nào đó 
--(Phụ thuộc dữ liệu nhập vào- VD:Máy xách tay)
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblNhaCungCap

SELECT dbo.tblMatHang.iMaNCC,dbo.tblNhaCungCap.sTenNhaCC,dbo.tblMatHang.sTenhang
FROM dbo.tblNhaCungCap,dbo.tblMatHang
WHERE dbo.tblMatHang.iMaNCC = dbo.tblNhaCungCap.iMaNCC AND sTenhang = N'Máy xách tay'

INSERT INTO dbo.tblMatHang
        ( sMahang ,
          sTenhang ,
          iMaNCC ,
          sMaloaihang ,
          fSoluong ,
          fGiaHang ,
          sDonvitinh
        )
VALUES  ( N'B13' , -- sMahang - nvarchar(10)
          N'Máy xách tay' , -- sTenhang - nvarchar(30)
          3 , -- iMaNCC - int
          N'A2' , -- sMaloaihang - nvarchar(10)
          10.0 , -- fSoluong - float
          33000.0 , -- fGiaHang - float
          N'VNĐ'  -- sDonvitinh - nvarchar(20)
        )

-- d) Tạo view cho biết số lượng đã bán được của từng nhân viên trong năm 2016
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM dbo.tblMatHang
CREATE VIEW view_hang2016
AS
SELECT dbo.tblChiTietDatHang.sMahang,dbo.tblMatHang.sTenhang,SUM(fSoluongmua) AS SL_Bán_2016
FROM dbo.tblDonDatHang,dbo.tblChiTietDatHang,dbo.tblMatHang
WHERE dbo.tblChiTietDatHang.iSoHD = dbo.tblDonDatHang.iSoHD AND dbo.tblChiTietDatHang.sMahang = dbo.tblMatHang.sMahang
AND YEAR(dbo.tblDonDatHang.dNgaydathang) = 2016
GROUP BY dbo.tblChiTietDatHang.sMahang,dbo.tblMatHang.sTenhang

SELECT * FROM view_hang2016

--e) Cho biết tổng số tiền hàng đã bán được của từng nhân viên trong năm 2016
SELECT * FROM dbo.tblNhanVien
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
SELECT dbo.tblNhanVien.iMaNV,dbo.tblNhanVien.sTenNV,SUM(fGiaban  * fSoluongmua) AS TTiền_2016
FROM dbo.tblNhanVien,dbo.tblChiTietDatHang,dbo.tblDonDatHang
WHERE dbo.tblNhanVien.iMaNV = dbo.tblDonDatHang.iMaNV AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
AND YEAR(dbo.tblDonDatHang.dNgaydathang) = 2016
GROUP BY dbo.tblNhanVien.iMaNV,dbo.tblNhanVien.sTenNV


--Bài 3.3)
--a) Lấy danh sách khách hàng nữ chưa đặt hàng lần nào
SELECT * FROM dbo.tblKhachHang
SELECT * FROM dbo.tblDonDatHang
--Dùng truy vấn lồng: những khách hàng ở bảng khách hàng mà không có trong bảng đơn đặt hàng
SELECT dbo.tblKhachHang.iMaKH,dbo.tblKhachHang.sTenKH,dbo.tblKhachHang.bGioitinh
FROM dbo.tblKhachHang
WHERE bGioitinh = 0
AND NOT EXISTS(
	SELECT iMaKH FROM dbo.tblDonDatHang WHERE dbo.tblKhachHang.iMaKH = dbo.tblDonDatHang.iMaKH
)


INSERT INTO dbo.tblKhachHang
        ( iMaKH ,
          sTenKH ,
          sDiachi ,
          sDienThoai ,
          bGioitinh
        )
VALUES  ( 06 , -- iMaKH - int
          N'Nguyễn Thị Ngọc Anh' , -- sTenKH - nvarchar(30)
          N'Thái nguyên' , -- sDiachi - nvarchar(50)
          N'0912923123' , -- sDienThoai - nvarchar(12)
          0  -- bGioitinh - bit
        )
INSERT INTO dbo.tblKhachHang
        ( iMaKH ,
          sTenKH ,
          sDiachi ,
          sDienThoai ,
          bGioitinh
        )
VALUES  ( 07 , -- iMaKH - int
          N'Nguyễn Thị Thắm' , -- sTenKH - nvarchar(30)
          N'Thái Bình' , -- sDiachi - nvarchar(50)
          N'0912923444' , -- sDienThoai - nvarchar(12)
          0  -- bGioitinh - bit
        )
INSERT INTO dbo.tblDonDatHang
        ( iSoHD ,
          iMaNV ,
          iMaKH ,
          dNgaydathang ,
          dNgaygiaohang ,
          sDiachigiaohang
        )
VALUES  ( 22 , -- iSoHD - int
          2 , -- iMaNV - int
          06 , -- iMaKH - int
          '2011-03-04' , -- dNgaydathang - datetime
          '2015-04-12' , -- dNgaygiaohang - datetime
          N'Tokyo'  -- sDiachigiaohang - nvarchar(50)
        )

--b) Thống kê số lượng đặt hàng của toàn bộ các mặt hàng thời trang(Kể cả các mặt hàng chưa đặt hàng lần nào)
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblLoaiHang
SELECT * FROM dbo.tblChiTietDatHang

SELECT * FROM dbo.tblLoaiHang
SELECT * FROM dbo.tblMatHang WHERE sMaloaihang = 'A4'
SELECT * FROM dbo.tblDonDatHang

--code: 
SELECT dbo.tblLoaiHang.sTenloaihang,SUM(dbo.tblChiTietDatHang.fSoluongmua) AS SL
FROM dbo.tblMatHang,dbo.tblLoaiHang,dbo.tblChiTietDatHang
WHERE dbo.tblMatHang.sMaloaihang = tblLoaiHang.sMaloaihang AND dbo.tblMatHang.sMahang = dbo.tblChiTietDatHang.sMahang
AND sTenloaihang = N'Thời trang'
GROUP BY sTenloaihang

INSERT INTO dbo.tblMatHang
        ( sMahang ,
          sTenhang ,
          iMaNCC ,
          sMaloaihang ,
          fSoluong ,
          fGiaHang ,
          sDonvitinh
        )
VALUES  ( N'B2' , -- sMahang - nvarchar(10)
          N'Bắn súng' , -- sTenhang - nvarchar(30)
          3 , -- iMaNCC - int
          N'A4' , -- sMaloaihang - nvarchar(10)
          200.0 , -- fSoluong - float
          199000.0 , -- fGiaHang - float
          N'VNĐ'  -- sDonvitinh - nvarchar(20)
        )
INSERT INTO dbo.tblChiTietDatHang
        ( iSoHD ,
          sMahang   ,
          fGiaban ,
          fSoluongmua ,
          fMucgiamgia
        )
VALUES  ( 3 , -- iSoHD - int
          N'10' , -- sMahang - nvarchar(10)
          9990.0 , -- fGiaban - float
          242.0 , -- fSoluongmua - float
          100.0  -- fMucgiamgia - float
        )

-- c) Lấy danh sách các khách hàng nam và tổng tiền đặt hàng của mỗi người
SELECT  * FROM dbo.tblKhachHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
SELECT dbo.tblKhachHang.iMaKH,dbo.tblKhachHang.sTenKH,dbo.tblKhachHang.bGioitinh,SUM(fGiaban * fSoluongmua) AS Tổng_Tiền_KH
FROM dbo.tblKhachHang,dbo.tblDonDatHang,dbo.tblChiTietDatHang
WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD AND dbo.tblKhachHang.iMaKH = dbo.tblDonDatHang.iMaKH
AND dbo.tblKhachHang.bGioitinh = 1
GROUP BY dbo.tblKhachHang.iMaKH,dbo.tblKhachHang.sTenKH,dbo.tblKhachHang.bGioitinh

-- d) Tạo view thống kê số lượng khách hàng theo giới tính
SELECT * FROM dbo.tblKhachHang
CREATE VIEW view_SLkhachhang
AS
SELECT bGioitinh,COUNT(iMaKH) AS SL_KhachHang
FROM dbo.tblKhachHang
GROUP BY bGioitinh
SELECT * FROM view_SLkhachhang

--e) Tạo view cho xem dach sách 3 khách hàng mua hàng nhiều lần nhất
SELECT * FROM dbo.tblKhachHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
CREATE VIEW view_KHtiemnang
AS 
SELECT TOP 3 dbo.tblDonDatHang.iMaKH,dbo.tblKhachHang.sTenKH,SUM(fSoluongmua) AS Max_SL
FROM dbo.tblKhachHang,dbo.tblDonDatHang,dbo.tblChiTietDatHang
WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD AND dbo.tblKhachHang.iMaKH = dbo.tblDonDatHang.iMaKH
GROUP BY dbo.tblDonDatHang.iMaKH,dbo.tblKhachHang.sTenKH
ORDER BY SUM(fSoluongmua) DESC

SELECT * FROM view_KHtiemnang

--f) Tạo view cho xem danh sách mặt hàng và giá bán trung bình của từng mặt hàng
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblChiTietDatHang

CREATE VIEW view_dsMathangVsGiaBanTB
AS
SELECT dbo.tblChiTietDatHang.sMahang,dbo.tblMatHang.sTenhang, AVG(fGiaban) AS Giaban_TB
FROM dbo.tblMatHang,dbo.tblChiTietDatHang
WHERE dbo.tblMatHang.sMahang = dbo.tblChiTietDatHang.sMahang
GROUP BY dbo.tblChiTietDatHang.sMahang,dbo.tblMatHang.sTenhang

SELECT * FROM view_dsmathangVsGiaBanTB

--g) Cập nhật giá bán (tblMathang.fGiahang) theo quy tắc:

--B1)Lập view Bảng giá max của từng 
SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM dbo.tblDonDatHang
CREATE VIEW view_BangGia
AS 
SELECT dbo.tblMatHang.sMahang,MAX(fGiahang) AS fGiaHang_MAX
FROM dbo.tblMatHang,dbo.tblChiTietDatHang,dbo.tblDonDatHang
WHERE dbo.tblMatHang.sMahang=dbo.tblChiTietDatHang.sMahang AND dbo.tblChiTietDatHang.iSoHD=dbo.tblDonDatHang.iSoHD 
AND dbo.tblDonDatHang.dNgaydathang>GETDATE()-30
GROUP BY dbo.tblMatHang.sMahang

SELECT * FROM view_BangGia

--B2)Kết nối với bảng Bảng giá 
UPDATE dbo.tblMatHang
SET fGiahang = fGiaHang_MAX * 1.1
FROM view_BangGia
WHERE view_BangGia.sMahang=dbo.tblMatHang.sMahang



--thêm đơn đặt hàng
INSERT INTO dbo.tblDonDatHang
        ( iSoHD ,
          iMaNV ,
          iMaKH ,
          dNgaydathang ,
          dNgaygiaohang ,
          sDiachigiaohang
        )
VALUES  ( 4 , -- iSoHD - int
          2 , -- iMaNV - int
          2 , -- iMaKH - int
          '2018-1-02' , -- dNgaydathang - datetime
          '2018-2-09' , -- dNgaygiaohang - datetime
          N'Hà Nam'  -- sDiachigiaohang - nvarchar(50)
        )
SELECT * FROM dbo.tblDonDatHang
INSERT INTO dbo.tblDonDatHang
        ( iSoHD ,
          iMaNV ,
          iMaKH ,
          dNgaydathang ,
          dNgaygiaohang ,
          sDiachigiaohang
        )
VALUES  ( 5 , -- iSoHD - int
          2 , -- iMaNV - int
          1 , -- iMaKH - int
          '2018-3-03' , -- dNgaydathang - datetime
          '2018-4-09' , -- dNgaygiaohang - datetime
          N'Thái nguyên'  -- sDiachigiaohang - nvarchar(50)
        )
--thêm chi tiết đặt hàng
SELECT * FROM dbo.tblChiTietDatHang
INSERT INTO dbo.tblChiTietDatHang
        ( iSoHD ,
          sMahang ,
          fGiaban ,
          fSoluongmua ,
          fMucgiamgia
        )
VALUES  ( 4 , -- iSoHD - int
          N'B4' , -- sMahang - nvarchar(10)
          3000.0 , -- fGiaban - float
          14.0 , -- fSoluongmua - float
          6.1  -- fMucgiamgia - float
        )
INSERT INTO dbo.tblChiTietDatHang
        ( iSoHD ,
          sMahang ,
          fGiaban ,
          fSoluongmua ,
          fMucgiamgia
        )
VALUES  ( 5 , -- iSoHD - int
          N'B2' , -- sMahang - nvarchar(10)
          3000.0 , -- fGiaban - float
          14.0 , -- fSoluongmua - float
          6.1  -- fMucgiamgia - float
        )


