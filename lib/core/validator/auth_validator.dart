class AuthValidator {
  static String? name({required String? value}) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  static String? email({required String? value}) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? password({required String? value}) {
    if (value == null || value.trim().isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }
    return null;
  }

  static String? confirmPassword({
    required String password,
    required String? confirmPassword,
  }) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Konfirmasi Kata Sandi tidak boleh kosong';
    }
    if (password.trim() != confirmPassword.trim()) {
      return 'Kata sandi tidak sama';
    }
    return null;
  }
}
