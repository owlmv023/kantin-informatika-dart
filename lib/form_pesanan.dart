import 'package:flutter/material.dart';
import 'menu.dart';
import 'pesanan.dart';

class FormPesanan extends StatefulWidget {
  const FormPesanan({
    super.key,
    required this.menu,
    this.pesananAwal,
  });

  final Menu menu;
  final Pesanan? pesananAwal;

  @override
  State<FormPesanan> createState() => _FormPesananState();
}

class _FormPesananState extends State<FormPesanan> {
  final _kunciForm = GlobalKey<FormState>();
  bool _sudahDiisi = false;
  int _jumlahPorsi = 1;
  String _catatanPesanan = ''; // Variabel untuk menyimpan catatan

  // Fungsi untuk memunculkan dialog konfirmasi keluar jika form sudah diisi
  Future<bool> _tanyaKeluar() async {
    final jawaban = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar tanpa menyimpan?'),
          content: const Text('Isian pesanan Anda akan hilang.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Batal keluar
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),  // Jadi keluar
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
    return jawaban ?? false;
  }

  void _simpan() {
    if (_kunciForm.currentState!.validate()) {
      _kunciForm.currentState!.save();
      
      // PERBAIKAN: Mengirim jumlah porsi DAN catatan sekaligus dalam bentuk Map
      Navigator.of(context).pop(
        Pesanan(
          menu: widget.menu,
          jumlahPorsi: _jumlahPorsi,
          catatan: _catatanPesanan,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Pesanan>(
      canPop: !_sudahDiisi, // Jika belum diisi, langsung izinkan kembali. Jika sudah, cegah!
      onPopInvokedWithResult: (sudahTutup, hasil) async {
        if (sudahTutup) {
          return;
        }
        final jadiKeluar = await _tanyaKeluar();
        if (jadiKeluar && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Pesan ${widget.menu.nama}')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _kunciForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextFormField 1: Jumlah Porsi
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Porsi',
                    border: OutlineInputBorder(),
                  ),
                  initialValue:
                      widget.pesananAwal?.jumlahPorsi.toString() ?? '1',
                  keyboardType: TextInputType.number,
                  onChanged: (nilai) {
                    if (!_sudahDiisi && nilai.trim().isNotEmpty) {
                      setState(() => _sudahDiisi = true);
                    }
                  },
                  validator: (nilai) {
                    if (nilai == null || nilai.isEmpty) {
                      return 'Jumlah porsi tidak boleh kosong';
                    }
                    if (int.tryParse(nilai) == null || int.parse(nilai) <= 0) {
                      return 'Masukkan angka yang valid';
                    }
                    return null;
                  },
                  onSaved: (nilai) {
                    _jumlahPorsi = int.parse(nilai ?? '1');
                  },
                ),
                const SizedBox(height: 16),

                // TextFormField 2: Catatan Pesanan
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Catatan (Opsional)',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: widget.pesananAwal?.catatan ?? '',
                  onChanged: (nilai) {
                    if (!_sudahDiisi && nilai.trim().isNotEmpty) {
                      setState(() => _sudahDiisi = true);
                    }
                  },
                  onSaved: (nilai) {
                    _catatanPesanan = nilai ?? '';
                  },
                ),
                const SizedBox(height: 24),

                FilledButton(
                  onPressed: _simpan,
                  child: Text(
                    widget.pesananAwal == null
                        ? 'Pesan'
                        : 'Simpan perubahan',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}