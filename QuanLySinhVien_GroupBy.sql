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
