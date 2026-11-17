import 'package:flutter/material.dart';
import 'pesanan.dart';

class FormUbahPesanan extends StatefulWidget {
  const FormUbahPesanan({super.key, required this.pesanan});

  final Pesanan pesanan;

  @override
  State<FormUbahPesanan> createState() => _FormUbahPesananState();
}

class _FormUbahPesananState extends State<FormUbahPesanan> {
  final _kunciForm = GlobalKey<FormState>();
  late TextEditingController _porsiController;
  late TextEditingController _catatanController;

  @override
  void initState() {
    super.initState();
    // Mengisi nilai awal dari data pesanan yang lama
    _porsiController = TextEditingController(text: widget.pesanan.jumlahPorsi.toString());
    _catatanController = TextEditingController(text: widget.pesanan.catatan);
  }

  @override
  void dispose() {
    _porsiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // Aksi simpan perubahan (Diubah)
  void _simpanPerubahan() {
    if (_kunciForm.currentState!.validate()) {
      Navigator.of(context).pop({
        'aksi': 'ubah',
        'jumlah': int.parse(_porsiController.text),
        'catatan': _catatanController.text,
      });
    }
  }

  // Aksi hapus pesanan (Dihapus)
  void _hapusPesanan() {
    Navigator.of(context).pop({
      'aksi': 'hapus',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah: ${widget.pesanan.menu.nama}'),
        actions: [
          // Tombol Hapus Pesanan
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _hapusPesanan,
            tooltip: 'Hapus Pesanan',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _kunciForm,
          child: Column(
            children: [
              TextFormField(
                controller: _porsiController,
                decoration: const InputDecoration(labelText: 'Jumlah Porsi', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (nilai) {
                  if (nilai == null || nilai.isEmpty) return 'Jumlah porsi wajib diisi';
                  if (int.tryParse(nilai) == null || int.parse(nilai) <= 0) return 'Masukkan angka valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _catatanController,
                decoration: const InputDecoration(labelText: 'Catatan', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(null), // Kemungkinan 3: Batal
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _simpanPerubahan,
                      child: const Text('Simpan Perubahan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}