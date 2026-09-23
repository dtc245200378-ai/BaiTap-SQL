# Nhật ký Tương tác AI (AI Prompt Log) - Chuyên đề Over-Indexing & Storage

## 1. Prompt về Tác hại của Index trên cột TEXT và BOOLEAN
- **User**: Trong MySQL, nếu tôi tạo Index trên một cột chứa văn bản dài (TEXT) và một cột kiểu BOOLEAN (0 và 1), điều này gây hại như thế nào đến RAM, Disk và Query Optimizer?
- **AI Summary**: Index trên cột `TEXT` gây phình to dung lượng đĩa và RAM. Cột `BOOLEAN` có Cardinality cực thấp (chỉ 2 giá trị), MySQL Optimizer sẽ bỏ qua Index này và ưu tiên Full Table Scan. Do đó, duy trì cây B-Tree chỉ làm chậm thao tác `INSERT/UPDATE` mà không mang lại lợi ích cho truy vấn.

## 2. Prompt về Lý do Query Optimizer bỏ qua Index Cardinality thấp
- **User**: Tại sao khi truy vấn SELECT * FROM Posts WHERE is_visible = 1 trên một bảng có hàng triệu dòng (với 99% bài viết visible = 1), MySQL lại chọn Full Table Scan thay vì dùng Index idx_is_visible?
- **AI Summary**: Khi tỷ lệ bản ghi thỏa mãn điều kiện quá cao (>20-30%), chi phí duyệt cây Index rồi thực hiện Random I/O để tìm về dữ liệu gốc cao hơn rất nhiều so với việc quét liên tục (Sequential I/O) toàn bộ bảng.

## 3. Prompt về Đo lường dung lượng bằng information_schema
- **User**: Hãy cho tôi xem truy vấn SQL sử dụng information_schema.TABLES để in ra kích thước Data và Index của bảng Posts tính theo MB.
- **AI Summary**: Trích xuất `data_length` và `index_length` từ `information_schema.TABLES` chia cho `1024 * 1024` để quy đổi ra Megabyte.
