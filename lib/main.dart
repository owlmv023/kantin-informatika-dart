import 'package:flutter/material.dart';
import 'menu.dart';
import 'data_dummy.dart';
import 'halaman_rinci_menu.dart';
import 'halaman_tentang.dart';
import 'halaman_utama.dart';
import 'pesanan.dart';
import 'jalur.dart';

void main() {
  runApp(const AplikasiKantin());
}

class AplikasiKantin extends StatelessWidget {
  const AplikasiKantin({super.key});

 @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Kantin Informatika',
    initialRoute: Jalur.utama,
    routes: {
      // Atur halaman awal ('/') langsung ke HalamanMenu atau HalamanUtama sesuai kebutuhan
      Jalur.utama: (context) => HalamanUtama(
        menuBuilder: (onTambahPesanan) =>
            HalamanMenu(onTambahPesanan: onTambahPesanan),
      ),
      '/tentang': (context) => const HalamanTentang(),
      },

    theme: ThemeData(
      primarySwatch: Colors.teal,
      useMaterial3: true,
    ),
    // PERBAIKAN: Baris 'home' dihapus karena rute '/' sudah mewakili halaman utama
  );
}
}

class HalamanMenu extends StatefulWidget {
  const HalamanMenu({
    super.key,
    required this.onTambahPesanan,
  });

  final ValueChanged<Pesanan> onTambahPesanan;

  @override
  State<HalamanMenu> createState() => _HalamanMenuState();
}

class _HalamanMenuState extends State<HalamanMenu> {
  late final TextEditingController _kataKunci;
  late final List<Menu> _semuaMenu;
  
  // State untuk menyimpan kategori yang sedang dipilih ('semua', 'makanan', 'minuman')
  String _kategoriAktif = 'semua';

  @override
  void initState() {
    super.initState();
    _kataKunci = TextEditingController();
    _semuaMenu = muatMenuBanyak(); // Memuat 60 data menu sekali saja di awal
  }

  @override
  void dispose() {
    _kataKunci.dispose();
    super.dispose();
  }

  // Getter untuk memfilter daftar menu berdasarkan kategori aktif & kata kunci pencarian
  List<Menu> get menuTersaring {
    final kunci = _kataKunci.text.toLowerCase().trim();
    
    // 1. Filter berdasarkan kategori aktif
    List<Menu> hasilKategori;
    if (_kategoriAktif == 'makanan') {
      hasilKategori = _semuaMenu.where((m) => m.kategori.toLowerCase() == 'makanan').toList();
    } else if (_kategoriAktif == 'minuman') {
      hasilKategori = _semuaMenu.where((m) => m.kategori.toLowerCase() == 'minuman').toList();
    } else {
      hasilKategori = _semuaMenu;
    }

    // 2. Filter berdasarkan kata kunci pencarian
    if (kunci.isEmpty) {
      return hasilKategori;
    }
    return hasilKategori
        .where((menu) => menu.nama.toLowerCase().contains(kunci))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasil = menuTersaring;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Kantin Informatika'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Kantin Informatika',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/tentang');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Kotak input untuk pencarian menu
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _kataKunci,
              decoration: const InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (teks) {
                setState(() {}); // Memperbarui tampilan saat diketik
              },
            ),
          ),
          
          // Tombol Tab Pemisah Kategori di dalam body (di bawah pencarian)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                _buildTombolKategori('Semua', 'semua'),
                const SizedBox(width: 8),
                _buildTombolKategori('Makanan', 'makanan'),
                const SizedBox(width: 8),
                _buildTombolKategori('Minuman', 'minuman'),
              ],
            ),
          ),
          
          const SizedBox(height: 8),

          // Daftar hasil pencarian atau pesan kosong
          Expanded(
            child: hasil.isEmpty
                ? const Center(
                    child: Text(
                      'Menu tidak ditemukan',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: hasil.length,
                    itemBuilder: (context, indeks) {
                      return KartuMenu(
                        menu: hasil[indeks],
                        onTambahPesanan: widget.onTambahPesanan,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk membuat tombol filter kategori yang interaktif
  Widget _buildTombolKategori(String label, String nilaiKategori) {
    final bool isSelected = _kategoriAktif == nilaiKategori;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _kategoriAktif = nilaiKategori;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF0E7A70) : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: isSelected ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}

// Widget Label Kategori yang dapat dipakai ulang
class LabelKategori extends StatelessWidget {
  const LabelKategori({super.key, required this.kategori});

  final String kategori;

  @override
  Widget build(BuildContext context) {
    Color warnaLatar;
    Color warnaTeks;

    final kat = kategori.toLowerCase();
    if (kat == 'makanan') {
      warnaLatar = const Color(0xFFB2DFDB); // Teal terang
      warnaTeks = const Color(0xFF004D40); // Teal gelap
    } else if (kat == 'minuman') {
      warnaLatar = const Color(0xFFBBDEFB); // Biru terang
      warnaTeks = const Color(0xFF0D47A1); // Biru gelap
    } else {
      // Untuk status 'habis' atau lainnya
      warnaLatar = Colors.grey.shade300;
      warnaTeks = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(12), // Sudut membulat
      ),
      child: Text(
        kategori,
        style: TextStyle(
          color: warnaTeks,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class KartuMenu extends StatelessWidget {
  const KartuMenu({
    super.key,
    required this.menu,
    required this.onTambahPesanan,
  });
 
  final Menu menu;
  final ValueChanged<Pesanan> onTambahPesanan;
 
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => HalamanRinciMenu(
                menu: menu,
                onTambahPesanan: onTambahPesanan,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                menu.kategori == 'minuman'
                    ? Icons.local_cafe
                    : Icons.restaurant,
                size: 36,
                color: const Color(0xFF0E7A70),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LabelKategori(
                      kategori: menu.tersedia ? menu.kategori : 'habis',
                    ),
                  ],
                ),
              ),
              Text(
                'Rp${menu.harga}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KartuMenuPetak extends StatelessWidget {
  const KartuMenuPetak({super.key, required this.menu});
 
  final Menu menu;
 
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              menu.kategori == 'minuman'
                  ? Icons.local_cafe
                  : Icons.restaurant,
              size: 28,
            ),
            Text(
              menu.nama,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text('Rp${menu.harga}'),
          ],
        ),
      ),
    );
  }
}

class PemilihPorsi extends StatefulWidget {
  const PemilihPorsi({super.key});

  @override
  State<PemilihPorsi> createState() => _PemilihPorsiState();
}

class _PemilihPorsiState extends State<PemilihPorsi> {
  int jumlah = 1;
 
  void tambah() {
    setState(() {
      jumlah = jumlah + 1;
    });
  }
 
  void kurang() {
    if (jumlah > 1) {
      setState(() {
        jumlah = jumlah - 1;
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Porsi: $jumlah'),
        IconButton(
          onPressed: kurang,
          icon: const Icon(Icons.remove),
        ),
        IconButton(
          onPressed: tambah,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}