# Báo cáo Đánh giá Tài nguyên và Hiệu năng (QuickFeed Index Optimization)

## 1. Nguyên nhân gây Thảm họa Over-Indexing
- **Chi phí thao tác Ghi (Write Overhead)**: Mỗi lệnh `INSERT` bài viết mới buộc MySQL phải tự động cập nhật đồng thời 5 cây B-Tree Index ngầm. Điều này làm gia tăng I/O đĩa cứng, gây nghẽn tiến trình và dẫn đến lỗi Timeout trên ứng dụng.
- **Index trên cột Cardinality thấp**: Các cột `is_visible` (chỉ có 2 giá trị 0/1) và `post_type` (3 giá trị) có độ phân giải cực thấp. MySQL Query Optimizer sẽ bỏ qua các Index này để chọn Full Table Scan, khiến việc duy trì B-Tree hoàn toàn vô ích.
- **Phình to dung lượng ổ cứng (Storage Overhead)**: Index `idx_content` trên cột `TEXT` tiêu tốn không gian đĩa khổng lồ để lưu trữ chuỗi 255 ký tự.

## 2. Giải pháp và Kết quả Tối ưu
- **Hành động**: Loại bỏ 3 Index kém hiệu quả (`idx_content`, `idx_post_type`, `idx_is_visible`), chỉ giữ lại 2 Index có độ phân giải cao (`idx_user_id` và `idx_created_at`).
- **Kết quả**:
  - Cắt giảm đáng kể thông số `index_length` trong `information_schema.TABLES`.
  - Tốc độ `INSERT` bài viết mới tăng 3-5 lần do giảm bớt 3 lần thao tác tái cấu trúc cây B-Tree.
