# BTLT8 - Nguyễn Lộc (645107043)

## Cấu trúc project
Project đã được setup toàn bộ code và cấu trúc thư mục theo yêu cầu:
- Tích hợp 7 câu (chọn ngẫu nhiên): 1, 2, 3, 4, 5, 7, 8.
- Các câu được phân tách cấu trúc rõ ràng: `apps, models, views, controllers, utils, widgets` bên trong thư mục `lib/cau_X`.
- Thư mục `KetQua_HinhAnh` chứa các thư mục con từ `Cau_1` đến `Cau_8` để bạn lưu ảnh chụp màn hình nộp bài.

## Hướng dẫn chạy và nộp bài
1. Mở Terminal/Command Prompt trong thư mục project `d:\Dart\NguyenLoc_645107043_BTLT8`.
2. Chạy ứng dụng bằng lệnh:
   ```bash
   flutter run
   ```
   (Chọn thiết bị chạy là Chrome, Edge hoặc máy ảo Android).
3. Giao diện trang chủ sẽ hiển thị Menu 7 câu. Bạn nhấn vào từng câu để chạy Demo.
4. Trên AppBar của mỗi màn hình đều có in sẵn `Nguyễn Lộc (645107043)`.
5. Bạn tiến hành chức năng CRUD, thao tác cơ bản sau đó chụp màn hình lại **(lưu ý chụp full màn hình để thấy được thanh Taskbar của Windows như yêu cầu)**.
6. Lưu ảnh vào các thư mục tương ứng trong thư mục `KetQua_HinhAnh` (ví dụ: hình câu 1 bỏ vào `KetQua_HinhAnh\Cau_1`).

## Hướng dẫn đẩy lên GitHub
Sau khi đã hoàn tất việc chụp ảnh kết quả, hãy đưa toàn bộ project lên Github theo hướng dẫn sau:
1. Lên Github tạo một Repository tên là: **NguyenLoc_645107043_BTLT8**
2. Mở Terminal tại thư mục project và chạy các lệnh:
```bash
git init
git add .
git commit -m "Hoan thanh BTLT 8"
git branch -M main
git remote add origin https://github.com/Ten_Github_Cua_Ban/NguyenLoc_645107043_BTLT8.git
git push -u origin main
```
(Nhớ thay đường link origin cho đúng với repo bạn vừa tạo).
