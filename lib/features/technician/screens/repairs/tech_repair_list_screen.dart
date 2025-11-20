import 'package:flutter/material.dart';

class TechRepairListScreen extends StatelessWidget {
  const TechRepairListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réparations assignées')),
      body: const Center(child: Text('Liste des réparations')),
    );
  }
}
