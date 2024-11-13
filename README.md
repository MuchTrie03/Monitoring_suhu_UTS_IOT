# Dashboard Monitoring Suhu

Proyek Flutter untuk memantau data suhu secara real-time dan menampilkannya pada dashboard interaktif.

---

## Pendahuluan

Proyek ini adalah titik awal untuk aplikasi **Flutter** yang memungkinkan pemantauan data suhu secara real-time. Ikuti langkah-langkah di bawah ini untuk mengatur dan menjalankan proyek secara lokal.

---

### Persyaratan

Sebelum menjalankan aplikasi, pastikan Anda telah menginstal perangkat berikut:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi stabil terbaru)
- IDE yang sesuai, seperti [Visual Studio Code](https://code.visualstudio.com/) atau [Android Studio](https://developer.android.com/studio)
- [Android Emulator](https://developer.android.com/studio/run/emulator) atau perangkat fisik yang terhubung (Android/iOS)
- [Xcode](https://developer.apple.com/xcode/) (untuk pengembangan iOS, hanya untuk pengguna macOS)
- **Python** (untuk menjalankan server)

---

### Menjalankan Aplikasi

Ikuti langkah-langkah ini untuk menjalankan aplikasi Flutter dan server backend secara lokal.

1. **Clone Repository**

   Mulailah dengan meng-clone repository proyek ke komputer lokal Anda menggunakan Git:

   ```bash
   git clone https://github.com/username/dashboard_monitoring_suhu.git

Ganti username dengan nama pengguna GitHub Anda atau pemilik repository.

Instal Dependensi Flutter

Masuk ke direktori proyek dan instal dependensi Flutter yang dibutuhkan:

bash
Copy code
```
cd dashboard_monitoring_suhu

```
flutter pub get
Perintah ini akan mengunduh dan menginstal semua dependensi yang tercantum di file pubspec.yaml.

Menjalankan Server Backend

Proyek ini membutuhkan server backend untuk menyediakan data suhu. Anda perlu menjalankan server secara lokal terlebih dahulu.

Pastikan Python telah terinstal pada sistem Anda. Lalu, masuk ke folder yang berisi script server (server.py) dan jalankan perintah berikut:

bash
Copy code
```
python server.py
```
Perintah ini akan menjalankan server yang akan menyediakan data yang dibutuhkan oleh aplikasi Flutter.

Menjalankan Aplikasi Flutter

Setelah server berjalan, Anda dapat meluncurkan aplikasi Flutter.

Jika Anda menggunakan emulator Android, pastikan emulator sudah berjalan.
Atau, hubungkan perangkat fisik melalui USB.
Jalankan aplikasi Flutter dengan perintah berikut:

bash
Copy code
```
flutter run
```
Perintah ini akan membangun dan meluncurkan aplikasi pada perangkat atau emulator yang terhubung.

