CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- 1. Khởi tạo cấu trúc bảng Transactions
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- 2. TẠO B-TREE COMPOSITE INDEX TỐI ƯU
-- Đặt cột lọc chính xác '=' (transaction_type) lên trước, cột lọc khoảng Range (created_at) đứng sau
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- ========================================================
-- TRUY VẤN ĐÃ TỐI ƯU HÓA (Viết lại dạng SARGable)
-- ========================================================
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';
