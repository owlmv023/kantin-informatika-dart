import 'package:flutter/material.dart';
import 'menu.dart'; // Mengimpor model data Menu yang sudah Anda miliki

class KartuMenu extends StatelessWidget {
  const KartuMenu({
    super.key,
    required this.menu,
    required this.onTap,
  });

  final Menu menu;
  final VoidCallback onTap; // Aksi yang dijalankan saat kartu diklik

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap, // Menghubungkan fungsi klik ke Navigator
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bagian Kiri: Nama dan Kategori Menu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: menu.tersedia ? Colors.teal.shade50 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        menu.kategori,
                        style: TextStyle(
                          fontSize: 12,
                          color: menu.tersedia ? Colors.teal.shade700 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bagian Kanan: Harga Menu
              Text(
                'Rp ${menu.harga}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}