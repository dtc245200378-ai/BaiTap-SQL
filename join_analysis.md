# Giải trình kỹ thuật: COUNT(o.order_id) vs COUNT(*) trong LEFT JOIN

Khi sử dụng `LEFT JOIN` để lấy danh sách tất cả khách hàng (bao gồm cả khách hàng chưa từng mua hàng), hàng trả về cho khách hàng chưa mua (như Charlie) sẽ chứa các giá trị `NULL` ở các cột thuộc bảng `Orders`.

- **`COUNT(*)`**: Đếm tổng số dòng bản ghi trả về bất kể giá trị chứa bên trong. Khi Charlie xuất hiện 1 dòng ghép với giá trị `NULL` của `Orders`, `COUNT(*)` vẫn tính dòng đó và trả về **1**, làm sai lệch báo cáo (hiểu nhầm Charlie đã mua 1 đơn).
- **`COUNT(o.order_id)`**: Bỏ qua các giá trị `NULL` và chỉ đếm các ô có dữ liệu thực sự. Đối với Charlie, giá trị `o.order_id` là `NULL`, do đó câu lệnh đếm đúng kết quả là **0** đơn hàng.

Vì vậy, việc dùng `COUNT(o.order_id)` là bắt buộc để đảm bảo tính toàn vẹn dữ liệu cho báo cáo Marketing.
