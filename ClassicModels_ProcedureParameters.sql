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
