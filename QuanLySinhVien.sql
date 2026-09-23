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
USE classicmodels;

-- 1. Xem kế hoạch thực thi trước khi tạo Index (MySQL sẽ thực hiện Full Table Scan)
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- 2. Thêm chỉ mục đơn (Single-column Index) cho cột customerName
ALTER TABLE customers ADD INDEX idx_customerName(customerName);

-- 3. Kiểm tra lại kế hoạch thực thi sau khi tạo Index (chuyển sang kiểu tìm kiếm ref/const)
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- 4. Thêm chỉ mục phức hợp (Composite Index) cho cặp cột contactFirstName và contactLastName
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- 5. Kiểm tra kế hoạch thực thi với chỉ mục phức hợp vừa tạo
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';

-- 6. Xóa chỉ mục idx_full_name khỏi bảng customers
ALTER TABLE customers DROP INDEX idx_full_name;
USE classicmodels;

-- 1. Tạo Stored Procedure lấy danh sách tất cả khách hàng
DELIMITER //
CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //
DELIMITER ;

-- 2. Gọi Stored Procedure
CALL findAllCustomers();

-- 3. Xóa và tạo lại Stored Procedure để lọc theo customerNumber = 175
DELIMITER //
DROP PROCEDURE IF EXISTS `findAllCustomers`//

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers WHERE customerNumber = 175;
END //
DELIMITER ;

-- 4. Gọi lại Stored Procedure sau khi cập nhật
CALL findAllCustomers();
USE classicmodels;

-- 1. Tham số loại IN: Lấy thông tin khách hàng theo customerNumber
DELIMITER //
DROP PROCEDURE IF EXISTS getCusById //
CREATE PROCEDURE getCusById(IN cusNum INT)
BEGIN
    SELECT * FROM customers WHERE customerNumber = cusNum;
END //
DELIMITER ;

-- Gọi Stored Procedure dạng IN
CALL getCusById(175);


-- 2. Tham số loại OUT: Đếm số lượng khách hàng theo thành phố
DELIMITER //
DROP PROCEDURE IF EXISTS GetCustomersCountByCity //
CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //
DELIMITER ;

-- Gọi Stored Procedure dạng OUT
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total;


-- 3. Tham số loại INOUT: Tăng giá trị biến đếm
DELIMITER //
DROP PROCEDURE IF EXISTS SetCounter //
CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //
DELIMITER ;

-- Gọi Stored Procedure dạng INOUT
SET @counter = 1;
CALL SetCounter(@counter, 1);
CALL SetCounter(@counter, 1);
CALL SetCounter(@counter, 5);
SELECT @counter;
USE classicmodels;

-- 1. Tạo View customer_views từ bảng customers
CREATE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Lấy dữ liệu từ view vừa tạo
SELECT * FROM customer_views;

-- 2. Cập nhật (Sửa đổi) View customer_views
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Lấy dữ liệu từ view sau khi cập nhật
SELECT * FROM customer_views;

-- 3. Xóa View customer_views
DROP VIEW customer_views;
CREATE DATABASE IF NOT EXISTS company;
USE company;

-- 1. Tạo bảng employees
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- 2. Tạo Trigger tự động phân loại phòng ban theo mức lương trước khi chèn dữ liệu
DELIMITER //

DROP TRIGGER IF EXISTS update_department //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;

-- 3. Thêm dữ liệu mẫu để kiểm tra Trigger
INSERT INTO employees (name, department, salary)
VALUES ('John Doe', 'A', 3500),
       ('Jane Smith', 'A', 2000),
       ('David Johnson', 'A', 6000);

-- Kiểm tra kết quả sau khi Trigger tự động cập nhật department
SELECT * FROM employees;
CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

-- 1. Khởi tạo cấu trúc bảng Posts
CREATE TABLE IF NOT EXISTS Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10), -- 'TEXT', 'IMAGE', 'VIDEO'
    is_visible BOOLEAN DEFAULT 1, -- 1 (Hiện) hoặc 0 (Ẩn)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Thêm các chỉ mục ban đầu (Legacy Indexing - Over-indexing crisis)
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);

-- 3. Truy vấn kiểm tra dung lượng Data & Index TRƯỚC khi tối ưu
SELECT 
    table_name AS 'Table',
    ROUND((data_length / 1024 / 1024), 2) AS 'Data_MB',
    ROUND((index_length / 1024 / 1024), 2) AS 'Index_MB',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total_MB'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- 4. Tiến hành DROP các Index dư thừa / Cardinality thấp / Tốn đĩa
ALTER TABLE Posts DROP INDEX idx_content;
ALTER TABLE Posts DROP INDEX idx_post_type;
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- 5. Truy vấn kiểm tra lại dung lượng Data & Index SAU khi tối ưu
SELECT 
    table_name AS 'Table',
    ROUND((data_length / 1024 / 1024), 2) AS 'Data_MB',
    ROUND((index_length / 1024 / 1024), 2) AS 'Index_MB',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total_MB'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';
