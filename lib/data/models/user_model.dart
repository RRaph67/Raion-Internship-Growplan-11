class UserModel {
final String? nama;
  final String? fotoProfil;
  final String? email;

UserModel({
  this.nama,
  this.fotoProfil,
  this.email,
});

  @override
  String toString() {
    return 'UserModel(nama: $nama, email: $email)';
  }
}
