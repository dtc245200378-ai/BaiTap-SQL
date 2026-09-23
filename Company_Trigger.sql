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
