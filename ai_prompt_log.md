# Nhật ký Tương tác AI (AI Prompt Log) - Chuyên đề Index & EXPLAIN

## 1. Prompt về Truy vấn Non-SARGable
- **User**: Trong MySQL, nếu tôi tạo Index cho một cột ngày tháng, nhưng trong mệnh đề WHERE tôi lại viết WHERE YEAR(col) = 2026, tại sao MySQL lại từ chối sử dụng Index và phải quét toàn bộ bảng (Full Table Scan)?
- **AI Summary**: B-Tree Index sắp xếp dữ liệu dựa trên giá trị thô của cột. Khi sử dụng hàm bọc quanh cột (`YEAR()`), MySQL không thể dùng cấu trúc cây tìm kiếm nhị phân có sẵn mà phải duyệt qua từng dòng dữ liệu để tính toán giá trị của hàm, dẫn đến Full Table Scan.

## 2. Prompt về Thứ tự cột trong Composite Index
- **User**: Khi thiết kế một Composite Index trong MySQL cho cột (transaction_type, created_at), thứ tự các cột trong Index có quan trọng không?
- **AI Summary**: Thứ tự cực kỳ quan trọng theo quy tắc Leftmost Prefix. Cột có điều kiện lọc chính xác bằng toán tử `=` (`transaction_type`) nên đặt trước, cột lọc khoảng Range (`created_at`) đặt sau để đạt hiệu quả Selectivity tốt nhất.

## 3. Prompt về Phân biệt Extra trong EXPLAIN
- **User**: Trong kết quả EXPLAIN, cột Extra hiện chữ "Using index condition" khác gì với "Using index" (Covering Index)?
- **AI Summary**: `Using index` nghĩa là toàn bộ cột cần lấy nằm hoàn toàn trong Index (Covering Index) không cần đọc lại bảng gốc. `Using index condition` (Index Condition Pushdown) nghĩa là MySQL dùng Index để lọc bớt các dòng trước khi đọc lại bảng dữ liệu chính, tiết kiệm chi phí I/O.
