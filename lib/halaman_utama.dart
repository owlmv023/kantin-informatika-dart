import 'package:flutter/material.dart';
import 'pesanan.dart';
import 'form_pesanan.dart';
import 'jalur.dart'; 

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({
    super.key,
    required this.menuBuilder,
  });

  final Widget Function(ValueChanged<Pesanan> onTambahPesanan) menuBuilder;
 
  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}
 
class _HalamanUtamaState extends State<HalamanUtama> {
  int _indeksTab = 0;

  // L1: Daftar penampung pesanan yang masuk ke keranjang
  final List<Pesanan> _daftarKeranjang = [];

  // Fungsi untuk menambahkan pesanan baru ke keranjang dan memperbarui tampilan
  void _tambahPesanan(Pesanan pesananBaru) {
    setState(() {
      _daftarKeranjang.add(pesananBaru);
    });
  }

  Future<void> _ubahPesanan(int indeks) async {
    final pesananLama = _daftarKeranjang[indeks];
    final pesananBaru = await Navigator.of(context).push<Pesanan>(
      MaterialPageRoute<Pesanan>(
        builder: (context) => FormPesanan(
          menu: pesananLama.menu,
          pesananAwal: pesananLama,
        ),
      ),
    );

    if (!mounted || pesananBaru == null) {
      return;
    }

    setState(() {
      _daftarKeranjang[indeks] = pesananBaru;
    });
  }

  Future<void> _hapusPesanan(int indeks) async {
    final hapus = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus pesanan?'),
        content: Text(
          'Pesanan ${_daftarKeranjang[indeks].menu.nama} akan dihapus dari keranjang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || hapus != true) {
      return;
    }

    setState(() {
      _daftarKeranjang.removeAt(indeks);
    });
  }

  void _bukaMenu() {
    setState(() {
      _indeksTab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menyiapkan daftar tab secara dinamis agar bisa mengakses _daftarKeranjang
    final List<Widget> isiTab = [
      widget.menuBuilder(_tambahPesanan),
      
      // Tampilan Tab Keranjang (L1)
      Scaffold(
        appBar: AppBar(title: const Text('Keranjang')),
        body: _daftarKeranjang.isEmpty
            ? const Center(child: Text('Keranjang masih kosong'))
            : ListView.builder(
                itemCount: _daftarKeranjang.length,
                itemBuilder: (context, indeks) {
                  final item = _daftarKeranjang[indeks];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.fastfood),
                      ),
                      title: Text(item.menu.nama),
                      subtitle: Text(
                        '${item.jumlahPorsi} porsi • Catatan: '
                        '${item.catatan.isEmpty ? 'Tanpa catatan' : item.catatan}',
                      ),
                      trailing: Wrap(
                        spacing: 0,
                        children: [
                          IconButton(
                            tooltip: 'Ubah pesanan',
                            onPressed: () => _ubahPesanan(indeks),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            tooltip: 'Hapus pesanan',
                            onPressed: () => _hapusPesanan(indeks),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _bukaMenu,
          icon: const Icon(Icons.add),
          label: const Text('Tambah pesanan'),
        ),
      ),

      // Tampilan Tab Akun
      const Center(child: Text('Halaman akun')),
    ];

    // L2: Hitung total jumlah porsi pesanan untuk badge ikon keranjang
    int totalPorsiKeranjang = _daftarKeranjang.fold(
      0,
      (total, item) => total + item.jumlahPorsi,
    );

    return Scaffold(
      body: isiTab[_indeksTab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeksTab,
        onDestinationSelected: (indeks) {
          setState(() => _indeksTab = indeks);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          
          // L2: Lencana jumlah pesanan pada ikon keranjang memakai parameter Badge
          NavigationDestination(
            icon: Badge(
              label: Text('$totalPorsiKeranjang'),
              isLabelVisible: totalPorsiKeranjang > 0, // Sembunyikan badge jika keranjang kosong
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
          
          const NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
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
                Navigator.of(context).pop(); // Tutup laci dulu
                Navigator.of(context).pushNamed(Jalur.tentang); // Menggunakan konstanta jalur
              },
            ),
          ],
        ),
      ),
    );
  }
}