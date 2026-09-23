CREATE DATABASE IF NOT EXISTS flashmart_db;
USE flashmart_db;

-- 1. Khởi tạo cấu trúc bảng
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY, 
    name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY, 
    product_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY, 
    customer_id INT, 
    product_id INT
);

-- Làm sạch dữ liệu trước khi chèn
TRUNCATE TABLE Orders;
TRUNCATE TABLE Customers;
TRUNCATE TABLE Products;

-- Chèn dữ liệu mẫu
INSERT INTO Customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie'); 
INSERT INTO Products VALUES (101, 'Laptop'), (102, 'Mouse'), (103, 'Keyboard'); 
INSERT INTO Orders VALUES (1001, 1, 101), (1002, 1, 102), (1003, 2, 101);

-- ========================================================
-- BÁO CÁO 1: Báo cáo cho Giám đốc Marketing 
-- Yêu cầu: Lấy tất cả khách hàng + Số đơn hàng (Gồm cả người mua 0 đơn)
-- Giải pháp: LEFT JOIN + COUNT(o.order_id)
-- ========================================================
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ========================================================
-- BÁO CÁO 2: Báo cáo cho Giám đốc Kho vận 
-- Yêu cầu: Tìm danh sách các sản phẩm chưa từng được bán ra (Anti-Join)
-- Giải pháp: LEFT JOIN + WHERE o.order_id IS NULL
-- ========================================================
SELECT 
    p.product_id, 
    p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
