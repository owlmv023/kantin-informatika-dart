class Menu {
  const Menu({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.tersedia,
    this.catatan,
  });
 
  final int id;
  final String nama;
  final int harga;
  final String kategori;
  final bool tersedia;
  final String? catatan;
 
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as int,
      nama: json['nama'] as String,
      harga: json['harga'] as int,
      kategori: json['kategori'] as String,
      tersedia: json['tersedia'] as bool,
      catatan: json['catatan'] as String?,
    );
  }
}