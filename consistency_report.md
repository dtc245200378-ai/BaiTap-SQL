# Báo Cáo Phân Tích Lỗ Hổng Dữ Liệu (Gap Analysis) - HealthSync

1. Theo dõi trạng thái lịch hẹn bằng thuộc tính Boolean (is_active): Quy trình nghiệp vụ yêu cầu 5 trạng thái vòng đời (PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED). Việc dùng kiểu BOOLEAN chỉ đại diện được 2 trạng thái đúng/sai, khiến hệ thống không thể biết lịch hẹn đang ở giai đoạn nào.
2. Thiếu thông tin tài chính và xử lý hủy lịch: Cơ sở dữ liệu cũ hoàn toàn vắng bóng các thuộc tính lưu trữ tiền cọc (deposit_amount), phí phạt (penalty_fee) và lý do hủy (cancel_reason). Điều này dẫn đến việc không thể thực hiện nghiệp vụ phạt cọc khi bệnh nhân hủy lịch sau khi đã xác nhận.
3. Thiếu hoàn toàn bảng Đơn thuốc (Prescriptions): Khi bác sĩ hoàn tất khám (COMPLETED), nghiệp vụ yêu cầu kê đơn thuốc gắn với lịch hẹn. Thiết kế cũ không có bảng lưu đơn thuốc và khóa ngoại kết nối với Appointments, gây lỗi hệ thống khi lưu thông tin khám bệnh.
