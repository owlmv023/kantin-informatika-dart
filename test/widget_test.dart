import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kantin_informatika/main.dart';

void main() {
  testWidgets('menampilkan daftar menu kantin', (WidgetTester tester) async {
    await tester.pumpWidget(const AplikasiKantin());

    expect(find.text('Menu Kantin Informatika'), findsOneWidget);
    expect(find.text('Nasi Goreng 1'), findsOneWidget);
    expect(find.text('Es Teh Manis 1'), findsOneWidget);
    expect(find.text('Soto Ayam 1'), findsOneWidget);
    expect(find.text('habis'), findsOneWidget);

    await tester.tap(find.text('Nasi Goreng 1').first);
    await tester.pumpAndSettle();

    expect(find.text('Harga: Rp15000'), findsOneWidget);
    expect(find.text('Kategori: makanan'), findsOneWidget);
  });

  testWidgets('laci navigasi terbuka dan menuju halaman tentang', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AplikasiKantin());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Kantin Informatika'), findsOneWidget);
    expect(find.text('Tentang'), findsOneWidget);

    await tester.tap(find.text('Tentang'));
    await tester.pumpAndSettle();

    expect(find.text('Aplikasi Kantin Informatika'), findsOneWidget);
  });

  testWidgets('pesanan tersimpan dan muncul di keranjang', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AplikasiKantin());

    await tester.tap(find.text('Nasi Goreng 1').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buat Pesanan'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '2');
    await tester.enterText(find.byType(TextFormField).at(1), 'Tanpa cabai');
    await tester.tap(find.text('Pesan').last);
    await tester.pumpAndSettle();

    expect(find.text('Sudah dipesan: 2 porsi'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    expect(find.text('Nasi Goreng 1'), findsOneWidget);
    expect(find.text('Catatan: Tanpa cabai'), findsOneWidget);
    expect(find.text('2 porsi • Catatan: Tanpa cabai'), findsOneWidget);

    await tester.tap(find.byTooltip('Ubah pesanan'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '3');
    await tester.enterText(find.byType(TextFormField).at(1), 'Pedas');
    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();

    expect(find.text('3 porsi • Catatan: Pedas'), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus pesanan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus').last);
    await tester.pumpAndSettle();

    expect(find.text('Keranjang masih kosong'), findsOneWidget);
  });
}
