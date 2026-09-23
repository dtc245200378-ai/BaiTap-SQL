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
