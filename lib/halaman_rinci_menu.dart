import 'package:flutter/material.dart';
import 'menu.dart';
import 'form_pesanan.dart';
import 'pesanan.dart'; // Pastikan diimpor untuk membuat objek Pesanan

class HalamanRinciMenu extends StatefulWidget {
  const HalamanRinciMenu({
    super.key, 
    required this.menu,
    this.onTambahPesanan, // Parameter callback untuk mengirim pesanan ke HalamanUtama (L1)
  });
 
  final Menu menu;
  final ValueChanged<Pesanan>? onTambahPesanan;
 
  @override
  State<HalamanRinciMenu> createState() => _HalamanRinciMenuState();
}

class _HalamanRinciMenuState extends State<HalamanRinciMenu> {
  int _porsiDipesan = 0;
  String _catatanTerakhir = ''; // Variabel untuk menampung teks catatan pesanan
 
  Future<void> _bukaForm() async {
    final pesananBaru = await Navigator.of(context).push<Pesanan>(
      MaterialPageRoute<Pesanan>(
        builder: (context) => FormPesanan(menu: widget.menu),
      ),
    );
 
    // Sesudah await, periksa apakah halaman masih aktif (mounted)
    if (!mounted) {
      return;
    }
    if (pesananBaru == null) {
      return; // Pengguna menekan tombol kembali (batal memesan)
    }

    // Kirim pesanan ke HalamanUtama jika fungsi callback tersedia
    widget.onTambahPesanan?.call(pesananBaru);
    
    setState(() {
      _porsiDipesan += pesananBaru.jumlahPorsi;
      _catatanTerakhir = pesananBaru.catatan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menu.nama),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.menu.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Kategori: ${widget.menu.kategori}'),
            Text('Harga: Rp${widget.menu.harga}'),
            const SizedBox(height: 8),
            Text('Keterangan Menu: ${widget.menu.catatan ?? 'Tanpa catatan'}'),
            Text(widget.menu.tersedia ? 'Tersedia' : 'Sedang habis'),
            const SizedBox(height: 16),
            
            // Menampilkan jumlah porsi yang sudah dipesan
            Text(
              'Sudah dipesan: $_porsiDipesan porsi',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Menampilkan catatan/keterangan yang baru saja diinput di form
            Text(
              'Catatan pesanan: ${_catatanTerakhir.isEmpty ? '-' : _catatanTerakhir}',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            
            const Spacer(), // Spacer untuk mendorong tombol ke bawah
            
            // Tombol Pesan yang memanggil fungsi _bukaForm
            FilledButton(
              onPressed: _bukaForm, // Memanggil fungsi _bukaForm saat ditekan
              child: const Text('Buat Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}