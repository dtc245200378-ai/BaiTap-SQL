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
-- Bước 1: Tạo cơ sở dữ liệu demo
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- Bước 2: Tạo bảng Products và chèn dữ liệu mẫu
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL UNIQUE,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10,2) NOT NULL,
    productAmount INT NOT NULL DEFAULT 0,
    productDescription TEXT,
    productStatus TINYINT DEFAULT 1
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) VALUES
('P001', 'iPhone 15 Pro', 999.99, 50, 'Flagship Smartphone', 1),
('P002', 'MacBook Air M2', 1199.00, 30, 'Lightweight Laptop', 1),
('P003', 'iPad Air 5', 599.50, 45, '10.9-inch Tablet', 1),
('P004', 'AirPods Pro 2', 249.00, 100, 'Noise Cancelling Earbuds', 1),
('P005', 'Apple Watch S9', 399.00, 25, 'Smartwatch', 0);

-- Bước 3: Thao tác với INDEX
-- EXPLAIN kiểm tra trước khi tạo Index
EXPLAIN SELECT * FROM Products WHERE productCode = 'P001';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 999.99;

-- Tạo Unique Index trên cột productCode
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- Tạo Composite Index trên 2 cột productName và productPrice
CREATE INDEX idx_name_price ON Products(productName, productPrice);

-- EXPLAIN kiểm tra sau khi tạo Index (chuyển sang tìm kiếm qua Index)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P001';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 999.99;

-- Bước 4: Thao tác với VIEW
-- 4.1 Tạo View
CREATE VIEW view_product_info AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

SELECT * FROM view_product_info;

-- 4.2 Tiến hành sửa đổi View
CREATE OR REPLACE VIEW view_product_info AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products
WHERE productStatus = 1;

SELECT * FROM view_product_info;

-- 4.3 Tiến hành xóa View
DROP VIEW view_product_info;

-- Bước 5: Thao tác với STORED PROCEDURE
-- 5.1 Procedure lấy tất cả thông tin sản phẩm
DELIMITER //
DROP PROCEDURE IF EXISTS getAllProducts //
CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;

-- 5.2 Procedure thêm một sản phẩm mới
DELIMITER //
DROP PROCEDURE IF EXISTS addProduct //
CREATE PROCEDURE addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status TINYINT
)
BEGIN
    INSERT INTO Products(productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //
DELIMITER ;

-- 5.3 Procedure sửa thông tin sản phẩm theo id
DELIMITER //
DROP PROCEDURE IF EXISTS updateProductById //
CREATE PROCEDURE updateProductById(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status TINYINT
)
BEGIN
    UPDATE Products
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //
DELIMITER ;

-- 5.4 Procedure xóa sản phẩm theo id
DELIMITER //
DROP PROCEDURE IF EXISTS deleteProductById //
CREATE PROCEDURE deleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //
DELIMITER ;

-- Demo gọi các Stored Procedure
CALL getAllProducts();
CALL addProduct('P006', 'Sony WH-1000XM5', 380.00, 15, 'Over-ear Headphones', 1);
CALL updateProductById(1, 'P001', 'iPhone 15 Pro Max', 1199.99, 40, 'Updated Flagship', 1);
CALL deleteProductById(5);
CALL getAllProducts();
