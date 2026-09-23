USE QuanLyBanHang;

-- 1. Thêm dữ liệu vào bảng Customer
INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50)
ON DUPLICATE KEY UPDATE cName=VALUES(cName), cAge=VALUES(cAge);

-- 2. Thêm dữ liệu vào bảng Order
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL)
ON DUPLICATE KEY UPDATE cID=VALUES(cID), oDate=VALUES(oDate), oTotalPrice=VALUES(oTotalPrice);

-- 3. Thêm dữ liệu vào bảng Product
INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2)
ON DUPLICATE KEY UPDATE pName=VALUES(pName), pPrice=VALUES(pPrice);

-- 4. Thêm dữ liệu vào bảng OrderDetail
INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3)
ON DUPLICATE KEY UPDATE odQTY=VALUES(odQTY);

-- YÊU CẦU TRUY VẤN:

-- Q1: Hiển thị oID, oDate, oTotalPrice của tất cả hóa đơn
SELECT oID, oDate, oTotalPrice 
FROM `Order`;

-- Q2: Hiển thị danh sách khách hàng đã mua hàng và danh sách sản phẩm được mua bởi các khách
SELECT DISTINCT c.cName, p.pName
FROM Customer c
JOIN `Order` o ON c.cID = o.cID
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;

-- Q3: Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
SELECT c.cName
FROM Customer c
LEFT JOIN `Order` o ON c.cID = o.cID
WHERE o.oID IS NULL;

-- Q4: Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (odQTY * pPrice)
SELECT o.oID, o.oDate, SUM(od.odQTY * p.pPrice) AS oPrice
FROM `Order` o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
GROUP BY o.oID, o.oDate;
