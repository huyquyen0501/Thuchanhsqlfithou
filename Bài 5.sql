USE ThucHanhBanHangFULL
GO

--Buổi 5
--Bài 5.1)

--a) Tạo tài khoản đăng nhập SQL Server có tên 'Capnhat'

CREATE LOGIN Capnhat WITH PASSWORD ='123456'
GO
USE ThucHanhBanHangFULL
GO
																							
--b) Tạo user trong DB tương ứng với login 'Capnhat' và thực hiện cấp quyền Insert, Updat
e, Delete

CREATE USER User1 FOR LOGIN Capnhat

--Cấp quyền
GRANT INSERT,UPDATE,DELETE TO User1

--c) Kiểm tra kết quả

---------------------------------------------------------------------------------------------

--Bài 5.2)
--a) tạo login đăng nhập SQL server có tên 'BanHang' và thực hiện cấp quyền Insert trên bảng 
--tblDonDatHang và tblChiTietDatHang
CREATE LOGIN BanHang WITH PASSWORD = '123456'
GO


--Tạo user
USE ThucHanhBanHangFULL
GO

CREATE USER User2 FOR LOGIN BanHang
GO
--DROP USER NguoiDung2

--Vao DB thuchanhbanhangFULL cap quyen
--Cấp quyền
GRANT INSERT ON dbo.tblDonDatHang TO User2
GRANT INSERT ON dbo.tblChiTietDatHang TO User2



--b) Tạo user và cấp quyền thực thi thủ tục ở bài 4.2
CREATE LOGIN phanb WITH PASSWORD = '123'
GO

USE ThucHanhBanHangFULL
GO
--Tạo user
CREATE USER NguoiDung3 FOR LOGIN phanb
--Cấp quyền thực thi 3 thủ tục bài 4.2
GRANT EXEC ON sp_Themdondathang TO NguoiDung3
GRANT EXEC ON sp_caud TO NguoiDung3
GRANT EXEC ON sp_tenmh TO NguoiDung3

--code text
--EXECUTE sp_ThemDonDatHang 1,3,'2017-09-04','2017-09-20',N'Hà Đông',1001
--EXECUTE sp_tenmh N'Bảo An',2018
--EXECUTE sp_caud N'Kinh dị'


--c) Chỉnh sửa quyền của người dùng ở ý b thêm quyền xem thông tin của bảng tblMatHang
GRANT SELECT ON dbo.tblMatHang TO NguoiDung3



----------------------------------------------------------------------------------
--Bài 5.3)
--a) Tạo 1 tài khoản SQL server login với tên truy cập 'U1'	và mật khẩu là 'a1b2c3'

CREATE LOGIN U1 WITH PASSWORD = 'a1b2c3'
--b) Tạo 1 user trong DB của bài tập này cho U1
CREATE USER NguoiDung4  FOR LOGIN U1
--c) Cho phép U1 được toàn quyền trên bảng tblKhachHang
GRANT ALL PRIVILEGES ON dbo.tblKhachHang TO NguoiDung4
--d) Tạo Role có tên "BPNhapHang" và cấp quyền
CREATE ROLE king
--Được thêm và xem, dữ liệu của tblNhaCungCap,tblDonNhapHang,tblChiTietNhapHang
--Cấp quyền cho Role
GRANT INSERT,SELECT ON dbo.tblNhaCungCap TO king
GRANT INSERT,SELECT ON dbo.tblDonNhapHang TO king
GRANT INSERT,SELECT ON dbo.tblChiTietNhapHang TO king
--Được xem dữ liệu của tblNhanVien,tblMatHang
GRANT SELECT ON dbo.tblNhanVien TO king
GRANT SELECT ON dbo.tblMatHang TO king
--Cấm thêm sửa, xóa, trên bảng tblKhachHang
DENY INSERT,ALTER,DELETE ON dbo.tblKhachHang TO king


--e) Đưa U1 vào làm thành viên của role BPNhapHang.Kiểm tra kết quả phân quyền 
--Thêm 1 đơn nhập hàng với 3 nhập hàng cần nhập (Bất kì)
--Thêm 1 khách hàng bất kì


--sp_a
--EXEC sp_addrolemember 'King', 'NguoiDung4'
--EXEC sp_addrolemember N'RoleName', N'UserName' 
