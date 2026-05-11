CREATE DATABASE QuanLyThuVien
use QuanLyThuVien

--1
CREATE TABLE DocGia(
	MaDG INT PRIMARY KEY,
	HoTen NVARCHAR(100) NOT NULL,
	Email VARCHAR(100) NOT NULL UNIQUE,
	Tuoi INT CHECK ( Tuoi BETWEEN 10 AND 80)
)
CREATE TABLE Sach(
	MaSach INT PRIMARY KEY,
	TenSach NVARCHAR(255) NOT NULL,
	TheLoai NVARCHAR(MAX),
	SoLuongTon INT DEFAULT 0 CHECK (SoLuongTon >= 0)
)
CREATE TABLE PhieuMuon(
	MaPhieu INT IDENTITY(1, 1) PRIMARY KEY,
	MaDG INT,
	MaSach INT,
	NgayMuon DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (MaDG) REFERENCES DocGia(MaDG),
	FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)
)
--2
INSERT INTO DocGia(MaDG, HoTen, Email, Tuoi) 
VALUES 
(1, N'Nguyễn Phúc Tiến', 'tien123@gmail.com', 20),
(2, N'Nguyễn Tuấn Việt', 'viet123@gmail.com', 25),
(3, N'Đào Hồng Luyến', 'luyen18@gmail.com', 18),
(4, N'Nguyễn Văn Bình', 'binh123@gmail.com', 19),
(5, N'Trần Thị Lan Anh', 'anh123@gmail.com', 18),
(6, N'Lê Thị Hải Yến', 'yen123@gmail.com', 25)

INSERT INTO Sach (MaSach, TenSach, TheLoai, SoLuongTon)
VALUES
(101, N'Lập trình C++', N'Tin học', 10),
(102, N'Lập trình hướng đối tượng ', N'Tin học', 8),
(103, N'Dế Mèn Phiêu Lưu Ký', N'Văn học', 5),
(104, N'Vũ trụ trong vỏ hạt dẻ', N'Khoa học', 7),
(105, N'Tâm lý học hành vi', N'Tâm lý', 6)

INSERT INTO PhieuMuon (MaDG, MaSach)
VALUES
(1, 101),
(2, 102),
(3, 103),
(4, 104),
(5, 105),
(6, 105)

--3
CREATE VIEW vw_DanhSachMuonSach
AS 
SELECT 
	p.MaPhieu, d.HoTen, s.TenSach, p.NgayMuon
 FROM PhieuMuon p
JOIN DocGia d ON p.MaDG = d.MaDG
JOIN Sach s ON p.MaSach = s.MaSach
--4
SELECT * FROM Sach
WHERE TheLoai = N'Tin Học'
AND SoLuongTon > 0
--5
SELECT DISTINCT d.HoTen, s.TenSach
FROM PhieuMuon p
JOIN DocGia d ON p.MaDG = d.MaDG
JOIN Sach s ON p.MaSach = s.MaSach
--6
CREATE TRIGGER trg_GiamTonKho_KhiMuon
ON PhieuMuon
AFTER INSERT
AS
BEGIN
	UPDATE Sach 
	SET SoLuongTon = SoLuongTon - 1
	FROM Sach s 
	JOIN inserted i ON s.MaSach = i.MaSach
END
--7 
SELECT * FROM Sach
WHERE MaSach = 101

INSERT INTO PhieuMuon (MaDG, MaSach)
VALUES (1, 101)

SELECT * FROM PhieuMuon
--8
CREATE PROCEDURE sp_DemSoLanMuonSach
@MaDG INT,
@TongSoLan INT OUTPUT
AS
BEGIN
	SELECT @TongSoLan = COUNT(*) 
	FROM PhieuMuon
	WHERE MaDG = @MaDG
END

--9
DECLARE @Tong INT
EXEC sp_DemSoLanMuonSach
	@MaDG = 1,
	@TongSoLan = @Tong OUTPUT
SELECT N'Tổng số lần mượn sách: ' AS ThongBao,
       @Tong AS TongSoLan
