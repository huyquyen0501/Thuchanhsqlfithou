Drop database if exists webbanhang;
create database webbanhang;
use webbanhang;

create table chucvu(
id int  primary key,
Tenchucvu nvarchar(20)
);
create table Nhanvien(
id int  primary key,
hoten nvarchar(50),
diachi nvarchar(50),
gioitinh nvarchar,
CMND nvarchar(12),
sodt int,
idchucvu int  not null,
email nvarchar(50),
ngaysinh date ,
ngayvaolam date,
foreign key (idchucvu) references chucvu(id)
);
alter table nhanvien
add luongcoban int ;
alter table nhanvien
alter column gioitinh nvarchar(3);

alter table nhanvien
add CONSTRAINT ngayvaolam check (datediff(year,ngaysinh,ngayvaolam)>17);
create table dangnhap(
idnhanvien int primary key,
username nvarchar(20),
password nvarchar(20),
foreign key (idnhanvien) references Nhanvien(id)
);
create table sanpham(
id int primary key,
tensanpham nvarchar(50),
hinhsanpham nvarchar(100),
mota nvarchar(500)
);
create table size(
id int  primary key,
tenkichthuoc nvarchar(10)

);
create table color(
id int  primary key,
tenmau nvarchar(50)
);
create table chitietsanpham
(
id int  primary key,
idsanpham int,
idsize int,
idcolor int,
soluong int,
giaitien int,
ngaynhap date,

foreign key (idsanpham) references sanpham(id),
foreign key (idsize) references size(id),
foreign key (idcolor) references color(id)
);

create table khuyenmai(
id int  primary key,
tenkhuyenmai nvarchar(100),
thoigianbatdau date,
thoigianketthuc date ,
hinhkhuyenmai varchar(100),
mota nvarchar(500)
);
alter table khuyenmai
add CONSTRAINT thoigianketthuc check (datediff(day,thoigianbatdau,thoigianketthuc)>0);
create table chitietkhuyenmai(
idkhuyenmai int  ,
idsanpham int  ,
giagiam int,
primary key(idkhuyenmai,idsanpham),
foreign key (idkhuyenmai) references khuyenmai(id),
foreign key (idsanpham) references sanpham(id)
);
create table Hoadon
(
	id int  primary key,
    tenkhachhang nvarchar(50),
    sodt nvarchar(10),
    Diachigiaohang nvarchar(100),
	idnhanvien int,
	idkhachhang int,
    ngaymua date,
	foreign key(idnhanvien) references nhanvien(id),	   
	foreign key(idkhachhang) references nhanvien(id)
    );
create table chitiethoadon(
	idhoadon int ,
	idchitietsanpham int,
    soluong int,
    giatien int,
	idkhuyenmai int ,
    primary key(idhoadon,idchitietsanpham),
    foreign key (idhoadon) references hoadon(id),
    foreign key (idchitietsanpham) references chitietsanpham(id),
	foreign key (idkhuyenmai) references khuyenmai(id)
   	 
    );
------------------Trigger can co----------------------

---------------trigger cho dat hang --------
create trigger dathang on   chitiethoadon after insert as
Begin
	update 	chitietsanpham
	set  soluong= chitietsanpham.soluong -(
		select soluong from	inserted
		where idchitietsanpham =chitietsanpham.id
	  )
	  from chitietsanpham
	  join inserted on chitietsanpham.id= inserted.idchitietsanpham
End
---------------- trigger huy hang --------------------
create trigger huydon on chitiethoadon after delete as
Begin
	update 	chitietsapham
	set  soluong= soluong +(
		select soluong from	inserted
		where idchitietsanpham =chitietsanpham.id
	  )
	  from chitietsanpham
	  join inserted on chitietsanpham.id= inserted.idchitietsanpham
End
-----------------create trigger check so luong hang ton truoc khi dat don---------------------
create trigger checkhang on chitiethoadon for insert,update
as
begin
	declare @idchitietsanpham int
	declare @soluong int
	declare @soluongcon int
	select @idchitietsanpham = idchitietsanpham from inserted
	select @soluong = soluong from inserted
	select @soluongcon = soluong from chitietsanpham   where @idchitietsanpham = chitietsanpham.id
	if(	 @soluong > @soluongcon)
		begin
		raiserror(N'Hàng trong kho không đủ',16,1)
		rollback tran
		end
end

-------------trigger check gia ban--------------
create trigger checkgiachitiethoadon on chitiethoadon for insert,update
as
begin
	declare @idchitietsanpham int
	declare @giaban int
	declare @giagoc int
	select @idchitietsanpham = idchitietsanpham from inserted
	select @giaban = giatien from inserted
	select @giagoc = chitietsanpham.giaitien from chitietsanpham where @idchitietsanpham = chitietsanpham.id
	if(@giaban < sum(@giagoc*1.5))
		begin
		raiserror(N'giá bán quá thấp',16,1)
		rollback tran
		end
end
------------trigger xác nhận giới tính chỉ là nam hoặc nữ------------------
create trigger chinhan on nhanvien for insert,update
as
	declare @gioitinh nvarchar(3)
begin
	select @gioitinh=gioitinh from inserted
	if(@gioitinh != N'nam' and @gioitinh != N'nữ')
		begin
		raiserror(N'giới tính sai, nhập lại',16,1)
		rollback tran
		end
end
/*-------------trigger với khách vip được lưu trữ------------------
create trigger khachhangvip on hoadon for insert ,update
as
	declare @idkhachhang int
	declare @idchucvu int
	declare @tenkhachhang nvarchar(50)
	declare @sodt nvarchar(10)
	declare @diachigiaohang nvarchar(100)

begin
	select @idkhachhang= idkhachhang from inserted
	select @idchucvu=  idchucvu where @idkhachhang = Nhanvien.id
	if(@idchucvu =4)
		begin
			
			set inserted.tenkhachhang =  (select nhanvien.hoten where @idkhachhang=Nhanvien.id	) 
			/*and
			set diachigiaohang = (select Nhanvien.diachi where @idkhachhang=Nhanvien.id) */
		end
	else
		begin
		raiserror(N'đây không phải khách hàng vip',16,1)
		rollback tran
		end
end	*/
------------------proc----------------------
Create proc khachhangvip 
@idhoadon int,
@idnhanvien int,
@idkhachhang int,
@ngaymua date
as
	begin
		insert into Hoadon(id,idnhanvien,idkhachhang,ngaymua )
		values(@idhoadon,@idnhanvien,@idkhachhang,@ngaymua)
		update Hoadon
		set tenkhachhang=Nhanvien.hoten,
			sodt=Nhanvien.sodt,
			Diachigiaohang=Nhanvien.diachi
			from Hoadon
			left join Nhanvien

		on @idkhachhang=Nhanvien.id
	end
EXECUTE  khachhangvip 22,1,2,'2019-7-27';
select * from Hoadon where id=22;

----------------login-------------
use webbanhang;
Create login admin with password ='huytrau12'
go
create user admin for login admin
go 
GRANT ALL PRIVILEGES to admin

Create login nhanvien with password ='hahahaha'
go 
create user nhanvienkho for login nhanvien
go
grant  ALL PRIVILEGES on chitietsanpham to nhanvienkho
grant  ALL PRIVILEGES on sanpham to nhanvienkho

create role marketing 
go
grant select on sanpham to marketing
grant select on chitietsanpham to marketing
grant  ALL PRIVILEGES on khuyenmai to marketing
grant  ALL PRIVILEGES on chitietkhuyenmai to marketing

drop role banhang
go
grant select on sanpham to banhang
grant select on chitietsanpham to banhang
grant insert on hoadon to banhang
grant select on chitiethoadon to banhang
---------------dòng chức vụ có thằng thứ 4 khách hàng thì set lương cơ bản là 0 và số cmnd là 0 nhé----------					  
 Insert into chucvu values(1,N'Nhân viên bán buôn'),(2,N'Nhân viên bán lẻ'),(3,N'Quản lí'),(4,N'Khách hàng');
 use webbanhang


  insert into Nhanvien(id,hoten,diachi,gioitinh,CMND,sodt,idchucvu,email,ngaysinh,ngayvaolam,luongcoban)
 values 
		(1,N'Trần Đức Huy',N'Hà Nội','nam','123456789',0347112405,1,'mashigood12@gmail.com','1997-04-28','2018-1-1',4000000),
		(2,N'Đào Thị Diễm Quyên',N'Hà Nội',N'nữ','4444333322',0399647769,4,'diemquyen79@gmail.com','1997-09-10','2017-1-5',null),
		(3,N'Nguyễn Thị Hà',N'Hồ Chí Minh',N'Nữ','223344556',0902121118,2,'nguyenthiha@gmail.com','1998-04-28','2018-1-1',2000000),
		(4,N'Nguyễn Thị Nhung',N'Hà Nội',N'Nữ','121234344',01693221839,3,'nguyenthinhung@gmail.com','1998-3-3','2018-1-1',5000000),
		(5,N'Trần Đào Tuệ An',N'Hà Nội',N'nữ','224622867',01266248569,4,'trandaotuean@gmail.com','2000-1-1','2018-1-2',null),
		(6,N'Nguyễn Vãn Anh',N'Hồ Chí Minh',N'nam','013506263',0984778887,2,'nguyenvananh@gmail.com','1999-5-4','2019-2-2',3000000),
		(7,N'Nguyễn Công Phượng',N'Nghệ An',N'nam','013511667',0234543555,3,'nguyencongphuong@gmail.com','1995-3-4','2019-4-2',1500000),
		(8,N'Trần Văn Sơn',N'Hà Nội',N'nam','224622867',01266245369,4,'tranvanson@gmail.com','2000-1-1','2018-1-2',null),
		(9,N'Nguyễn Ngọc Ánh',N'Hồ Chí Minh',N'nữ','01346263',0981778887,2,'nguyenngocanh@gmail.com','1999-5-4','2019-2-2',3000000),
		(10,N'Nguyễn Thị Tươi',N'Nghệ An',N'nữ','013545667',0234543665,4,'nguyenthituoi@gmail.com','1995-3-4','2019-4-2',null),
		(11,N'Nguyễn Thị Thắm',N'Nghệ An',N'nữ','013586567',0234583555,4,'nguyenthitham@gmail.com','1995-3-4','2019-4-2',null);

  use webbanhang
 insert into dangnhap(idnhanvien,username,password) 
 values
		(1,'mashigood12','huytrau12'),
		(2,'diemquyen79','diemquyen79123'),
		(3,'nguyenthiha','nguyenthiha123'),
		(4,'nguyenthinhung','nguyenthinhung123'),
		(5,'trandaotuean','trandaotuean123'),
		(6,'nguyenvananh','nguyenvananh123'),
		(7,'nguyencongphuong','nguyencongphuong123'),
		(8,'tranvanson','tranvanson123'),
		(9,'nguyenngocanh','nguyenngocanh123'),
		(10,'nguyenthituoi','nguyenthituoi123'),
		(11,'nguyenthitham','nguyenthitham123');
 
 insert into sanpham(id,tensanpham,mota) 
 values
	(1,N'áo da bò',N'Hàng Việt Nam chất lượng cao'),
	(2,N'áo phông dài tay',N'Hàng Trung Quốc'),
	(3,N'Áo phông',N'áo phông may 10'),
	(4,N'quần đùi',N'Hàng Việt Nam chất lượng cao'),
	(5,N'quần âu',N'Hàng Trung Quốc'),
	(6,N'quần jen',N'áo phông may 10'),
	(7,N'mũ',N'Hàng Việt Nam chất lượng cao'),
	(8,N'bộ quần áo vest',N'Hàng Trung Quốc'),
	(9,N'đồng hồ',N'áo phông may 10'),
	(10,N'áo ba lỗ',N'áo phông may 10');

 insert into size(id,tenkichthuoc) values (1,'S'),(2,'M'),(3,'L'),(4,'XL'),(5,'XXL'),(6,'XXXL');
 insert into color(id,tenmau) values(1,N'Hồng'),(2,N'Xanh Lá'),(3,N'Vàng'),(4,N'Tím'),(5,N'ĐỎ'),(6,N'Nâu'),(7,N'Cam'),(8,N'Xám'),(9,N'Đen'),(10,N'Xanh Da Trời');
 insert into chitietsanpham(id,idsanpham,idsize,idcolor,soluong,giaitien,ngaynhap) 
 values
		(1,1,1,1,20,300000,'2019-5-20'),
		(2,2,2,2,10,400000,'2019-4-20'),
		(3,1,1,1,20,100000,'2018-5-20'),
		(4,2,2,2,10,800000,'2018-1-20'),
		(5,1,1,1,20,600000,'2018-5-20'),
		(6,2,2,2,10,800000,'2018-4-20'),
		(7,1,1,1,20,900000,'2018-5-20'),
		(8,2,2,2,10,2000000,'2018-4-20'),
		(9,1,1,1,20,600000,'2018-5-20'),
		(10,2,2,2,10,500000,'2018-4-20');
 insert into khuyenmai(id,tenkhuyenmai,thoigianbatdau,thoigianketthuc,mota) 
 values
		(1,N'Mừng sinh nhật chủ cửa hàng','2019-6-6','2019-6-9',N'Mừng sinh nhật chủ cửa hàng'),
		(2,N'Mừng ngày phụ nữ Việt Nam','2018-10-20','2018-11-1',N'Mừng ngày phụ nữ Việt Nam'),
		(3,N'Mừng black friday ','2018-11-23','2019-12-12',N'Mừng black friday '),
		(4,N'Mừng ngày quốc tế phụ nữ','2019-3-8','2019-3-12',N'Mừng ngày quốc tế phụ nữ'),
		(5,N'Mừng nhà giáo việt nam','2018-11-20','2018-11-22',N'Mừng nhà giáo việt nam');
 insert into chitietkhuyenmai(idkhuyenmai,idsanpham,giagiam) 
 values
		(1,1,10),
		(2,3,5),
		(3,2,6),
		(4,5,8),
		(5,7,12);
 insert into Hoadon(id,tenkhachhang,sodt,Diachigiaohang,idnhanvien,ngaymua) 
 values
		(99,N'Trần Đào Tuệ An','0126624856',N'96B Định Công Hạ, Hoàng Mai Hà Nội',1,'2019-7-10'),
		(45,N'Nguyễn Thị Thắm','023458355',N'69 Định Công , Hoàng Mai Hà Nội',2,'2018-10-20'),
		(24,N'Đào Thị Diễm Quyên','0399657769',N'123 Định Công , Hoàng Mai Hà Nội',2,'2018-11-23'),
		(68,N'Trần Văn Sơn','0126624539',N'12 Ngọc Hồi, Hoàng Mai Hà Nội',1,'2019-3-8'),
		(79,N'Nguyễn Thị Tươi','023454665',N'45 Đại Từ , Hoàng Mai Hà Nội',2,'2019-7-9'),
		(88,N'Trần Đào Tuệ An','0126624569',N'34 Giáp Bát , Hoàng Mai Hà Nội',1,'2019-7-10');
 insert into chitiethoadon(idhoadon,idchitietsanpham,soluong,giatien)
 values 
		(99,1,10,450000),
		(45,3,10,450000),
		(24,5,10,450000),
		(68,2,10,450000),
		(88,6,10,450000),
		(79,4,10,450000);

 		drop trigger huydon
	   delete from chitiethoadon
	   delete from Hoadon
-----Phan tan theo chuc vu-----
		-----nhanvien và khách hàng di theo chuc vu-----
				----hoadon di theo nhanvien------------
					----chitiethoadon đi theo hoadon--------
				----dang nhap đi theo nhân viên
select * from nhanvien
select COUNT(*) from Nhanvien where Nhanvien.id=1
