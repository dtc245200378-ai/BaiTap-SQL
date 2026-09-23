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
