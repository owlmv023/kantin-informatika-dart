import 'package:flutter/material.dart';
 
class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang')),
      body: const Center(
        child: Text('Aplikasi Kantin Informatika'),
      ),
    );
  }
}