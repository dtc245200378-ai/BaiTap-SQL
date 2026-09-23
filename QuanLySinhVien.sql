USE QuanLySinhVien;

-- 1. Hiển thị số lượng sinh viên ở từng nơi
SELECT Address, COUNT(StudentId) AS 'SoLuongHocVien'
FROM Student
GROUP BY Address;

-- 2. Tính điểm trung bình các môn học của mỗi học viên
SELECT S.StudentId, S.StudentName, AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S 
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;

-- 3. Hiển thị những bạn học viên có điểm trung bình các môn học lớn hơn 15
SELECT S.StudentId, S.StudentName, AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S 
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(M.Mark) > 15;

-- 4. Hiển thị thông tin các học viên có điểm trung bình lớn nhất
SELECT S.StudentId, S.StudentName, AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S 
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(M.Mark) >= ALL (
    SELECT AVG(Mark) 
    FROM Mark 
    GROUP BY StudentId
);
USE QuanLySinhVien;

-- 1. Hiển thị tất cả các thông tin môn học (bảng Subject) có credit lớn nhất
SELECT *
FROM Subject
WHERE Credit = (SELECT MAX(Credit) FROM Subject);

-- 2. Hiển thị các thông tin môn học có điểm thi lớn nhất
SELECT Sub.*, M.Mark
FROM Subject Sub
JOIN Mark M ON Sub.SubId = M.SubId
WHERE M.Mark = (SELECT MAX(Mark) FROM Mark);

-- 3. Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần
SELECT S.*, AVG(M.Mark) AS DiemTrungBinh
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId
ORDER BY DiemTrungBinh DESC;
