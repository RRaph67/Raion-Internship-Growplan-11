🌿 GrowPlan

GrowPlan adalah aplikasi manajemen perawatan tanaman cerdas yang dirancang untuk membantu pecinta tanaman memantau pertumbuhan, menjadwalkan perawatan, dan mengelola koleksi tanaman mereka secara digital. Dengan antarmuka yang modern dan integrasi cloud, GrowPlan memastikan tanaman Anda selalu mendapatkan perhatian yang mereka butuhkan.

✨ Fitur Utama

Aplikasi GrowPlan hadir dengan serangkaian fitur andalan:

Manajemen Koleksi (Plant Gallery): Pengguna dapat menambahkan tanaman pribadi, memberikan nama unik, dan mengunggah foto tanaman ke galeri digital.

Katalog Repositori Tanaman: Akses ke database berbagai jenis tanaman (Tanaman Hias, Sayur, Buah, dll.) untuk mempermudah identifikasi kebutuhan perawatan.

Pelacakan Usia Tanaman: Fitur kalkulasi otomatis untuk menghitung berapa hari sejak tanggal tanam pertama hingga saat ini.

Sistem Autentikasi: Keamanan data pengguna terjamin melalui sistem Login dan Register yang terintegrasi dengan Supabase Auth.

Sinkronisasi Cloud Real-time: Semua data tanaman tersimpan secara aman di cloud, memungkinkan akses lintas perangkat tanpa kehilangan data.

UI Responsif: Desain antarmuka yang bersih, intuitif, dan ramah pengguna dengan skema warna alam yang menenangkan.

🛠 Tech Stack

GrowPlan dibangun menggunakan teknologi mutakhir untuk memastikan performa dan skalabilitas:

Frontend: Flutter (Dart SDK)

Backend & Database: Supabase (PostgreSQL)

State Management: Flutter BLoC/Cubit

Autentikasi: Supabase Auth (Email & Password)

Penyimpanan Gambar: Supabase Storage

Routing: Navigator 2.0 / Flutter Material Routing

🏗 Arsitektur Aplikasi

GrowPlan mengadopsi pola Clean Architecture yang dipadukan dengan BLoC Pattern. Struktur proyek dibagi menjadi beberapa lapisan utama untuk memastikan kode yang rapi dan modular:

Struktur Folder Utama:

core/: Berisi komponen global yang digunakan di seluruh aplikasi.

theme/: Konfigurasi tema global (warna, tipografi, dan gaya komponen UI) agar tampilan aplikasi konsisten.

validators/: Logika validasi input form (seperti validasi email, password, dan field wajib) untuk menjaga integritas data sebelum dikirim ke backend.

data/: Berisi implementasi repository, data providers, dan model-model data (misal: UserTanamModel).

domain/: Lapisan inti yang berisi entitas dan kontrak repository (abstraksi).

presentation/: Berisi UI (Pages & Widgets) serta logika state management menggunakan Cubit.

cubit/: Mengelola state aplikasi (seperti UserTanamCubit).

pages/: Folder utama untuk setiap layar aplikasi (Login, Home, Add Plant, Detail).

📱 Cakupan Platform

Berkat fleksibilitas Flutter, GrowPlan dirancang untuk berjalan secara optimal di berbagai platform:

Platform

Status

Catatan

Android

✅ Supported

Kompatibel dengan Android API 21 ke atas.

iOS

✅ Supported

Desain adaptif mengikuti standar Human Interface Guidelines.

Web

✅ Supported

Responsif untuk berbagai resolusi layar desktop.

Desktop

🛠 Optional

Mendukung Windows/macOS dengan penyesuaian layout.

🚀 Cara Menjalankan Proyek

Clone Repositori:

git clone [https://github.com/username/growplan.git](https://github.com/username/growplan.git)


Instal Dependensi:

flutter pub get


Konfigurasi Supabase:
Dapatkan URL dan Anon Key dari dashboard Supabase Anda, lalu masukkan ke dalam inisialisasi pada main.dart.

Jalankan Aplikasi:

flutter run


Dikembangkan dengan ❤️ oleh Tim GrowPlan.