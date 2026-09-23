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
