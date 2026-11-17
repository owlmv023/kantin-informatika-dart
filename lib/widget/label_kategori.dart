
import 'package:flutter/material.dart';

// Widget LabelKategori tunggal yang bersih dan bebas error
class LabelKategori extends StatelessWidget {
  const LabelKategori({
    super.key,
    required this.kategori,
  });

  final String kategori;

  @override
  Widget build(BuildContext context) {
    Color warnaLatar;
    Color warnaTeks;

    final kat = kategori.toLowerCase();
    if (kat == 'makanan') {
      warnaLatar = Colors.teal.shade100; // Teal terang untuk makanan
      warnaTeks = Colors.teal.shade900;  // Teal gelap
    } else if (kat == 'minuman') {
      warnaLatar = Colors.blue.shade100; // Biru terang untuk minuman
      warnaTeks = Colors.blue.shade900;  // Biru gelap
    } else {
      warnaLatar = Colors.grey.shade300;  // Untuk 'habis' atau kategori lain
      warnaTeks = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(6.0), // Sudut membulat
      ),
      child: Text(
        kategori,
        style: TextStyle(
          color: warnaTeks,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}