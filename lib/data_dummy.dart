import 'dart:convert';
import 'menu.dart';

const String jsonMenu = '''
{
  "status": "sukses",
  "data": [
    {"id": 1, "nama": "Nasi Goreng", "harga": 15000,
     "kategori": "makanan", "tersedia": true, "catatan": null},
    {"id": 2, "nama": "Es Teh Manis", "harga": 5000,
     "kategori": "minuman", "tersedia": true, "catatan": null},
    {"id": 3, "nama": "Soto Ayam", "harga": 17000,
     "kategori": "makanan", "tersedia": false, "catatan": null}
  ]
}
''';
 
List<Menu> muatMenuDummy() {
  final peta = jsonDecode(jsonMenu) as Map<String, dynamic>;
  final daftar = peta['data'] as List<dynamic>;
  return daftar
      .map((item) => Menu.fromJson(item as Map<String, dynamic>))
      .toList();
}List<Menu> muatMenuBanyak() {
  final asli = muatMenuDummy();
  final hasil = <Menu>[];
  for (var putaran = 1; putaran <= 20; putaran++) {
    for (final menu in asli) {
      hasil.add(
        Menu(
          id: hasil.length + 1,
          nama: '${menu.nama} $putaran',
          harga: menu.harga,
          kategori: menu.kategori,
          tersedia: menu.tersedia,
          catatan: menu.catatan,
        ),
      );
    }
  }
  return hasil;
}