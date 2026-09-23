# Báo cáo Phân tích Hiệu năng Truy vấn (EXPLAIN Analysis)

## 1. Trước khi tối ưu (Legacy Query)
- **Dạng truy vấn**: Non-SARGable (Do bọc các hàm `YEAR()` và `MONTH()` xung quanh cột `created_at`).
- **Chỉ số EXPLAIN**:
  - `type`: **ALL** (Full Table Scan - Quét toàn bộ 5,000,000 dòng).
  - `possible_keys`: `NULL`.
  - `rows`: Quét toàn bộ ~5,000,000 dòng trong bảng.
- **Hậu quả**: Chiếm dụng 100% CPU máy chủ, gây khóa bảng và lỗi Timeout giao dịch.

## 2. Sau khi tối ưu (Optimized Query)
- **Giải pháp**: Tạo Composite Index `idx_type_date(transaction_type, created_at)` và chuyển đổi điều kiện `WHERE` sang dạng lọc khoảng (Range) `created_at >= '2026-06-01' AND created_at < '2026-07-01'`.
- **Chỉ số EXPLAIN**:
  - `type`: **range** (hoặc **ref**).
  - `key`: `idx_type_date`.
  - `rows`: Giảm từ 5,000,000 dòng xuống chỉ còn vài nghìn dòng thuộc tháng 06/2026.
  - `Extra`: `Using index condition`.

## 3. Kết luận
Tái cấu trúc truy vấn dạng SARGable giúp MySQL tận dụng cơ chế tìm kiếm B-Tree Index, giải phóng CPU và xử lý sự cố nghẽn hệ thống.
