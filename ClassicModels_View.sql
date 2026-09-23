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
