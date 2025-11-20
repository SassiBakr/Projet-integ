import 'package:flutter/material.dart';

class RepairListScreen extends StatelessWidget {
  const RepairListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Réparations')),
      body: const Center(child: Text('Liste des réparations')),
    );
  }
}
