# Nhật ký tương tác AI (AI Prompt Log) - Chuyên đề SQL JOIN

## 1. Prompt về sự khác biệt giữa INNER JOIN và LEFT JOIN
- **User**: Mặc định từ khóa JOIN trong MySQL hoạt động như thế nào? Sự khác biệt giữa INNER JOIN và LEFT JOIN khi xử lý các bản ghi không trùng khớp là gì?
- **AI Summary**: Từ khóa `JOIN` mặc định là `INNER JOIN`, chỉ trả về các dòng thỏa mãn điều kiện kết hợp ở cả 2 bảng. `LEFT JOIN` giữ lại toàn bộ các dòng từ bảng bên trái (Driving Table) và điền `NULL` vào các cột của bảng bên phải nếu không tìm thấy dữ liệu liên kết trùng khớp.

## 2. Prompt về COUNT(*) vs COUNT(column) khi dùng LEFT JOIN
- **User**: Khi tôi sử dụng LEFT JOIN và đếm số lượng đơn hàng bằng hàm COUNT, sự khác biệt giữa COUNT(*) và COUNT(tên_cột_khóa_chính_bảng_order) khi kết quả trả về NULL là gì?
- **AI Summary**: `COUNT(*)` đếm số dòng (bao gồm các dòng chứa NULL), làm sai lệch kết quả của bản ghi mồ côi thành 1. Trong khi đó `COUNT(column)` tự động bỏ qua giá trị `NULL`, giúp trả về kết quả 0 chính xác cho khách hàng chưa phát sinh đơn hàng.

## 3. Prompt về Tối ưu hiệu năng Anti-Join vs Subquery
- **User**: Hãy phân tích hiệu năng của việc dùng LEFT JOIN kết hợp IS NULL (Anti-Join) so with việc dùng subquery NOT IN khi tìm kiếm các bản ghi không tồn tại trong bảng khác.
- **AI Summary**: `LEFT JOIN ... WHERE IS NULL` cho phép MySQL Optimizer tối ưu tốt hơn nhờ thuật toán Hash Join hoặc Nested-Loop Join có chỉ mục, tránh rủi ro quét toàn bảng (Full Table Scan) hoặc bị sai logic do chứa giá trị NULL như khi dùng `NOT IN`.
