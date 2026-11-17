import 'package:flutter/material.dart';
import 'menu.dart'; // Sesuaikan dengan lokasi file class Menu Anda
import 'halaman_rinci_menu.dart'; // Halaman tujuan saat kartu diklik

class HalamanMenu extends StatelessWidget {
  const HalamanMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy sementara (hasil dari API atau database lokal)
    final List<Menu> hasil = [
      const Menu(
        id: 1,
        nama: 'Nasi Goreng Spesial',
        harga: 25000,
        kategori: 'Makanan',
        tersedia: true,
      ),
      const Menu(
        id: 2,
        nama: 'Es Teh Manis',
        harga: 5000,
        kategori: 'Minuman',
        tersedia: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
        // Properti actions diletakkan di dalam AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).pushNamed('/tentang');
            },
          ),
        ],
      ),
      // Menggunakan ListView.builder untuk merender daftar menu dari data dummy
      body: ListView.builder(
        itemCount: hasil.length,
        itemBuilder: (context, indeks) {
          return KartuMenu(
            menu: hasil[indeks],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) {
                    return HalamanRinciMenu(menu: hasil[indeks]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Widget KartuMenu untuk menampilkan setiap item menu dalam bentuk card
class KartuMenu extends StatelessWidget {
  const KartuMenu({super.key, required this.menu, required this.onTap});

  final Menu menu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(menu.nama),
        subtitle: Text('Rp ${menu.harga} • ${menu.kategori}'),
        trailing: Icon(
          Icons.circle,
          color: menu.tersedia ? Colors.green : Colors.red,
          size: 12,
        ),
        onTap: onTap, // Menjalankan navigasi saat kartu ditekan
      ),
    );
  }
}