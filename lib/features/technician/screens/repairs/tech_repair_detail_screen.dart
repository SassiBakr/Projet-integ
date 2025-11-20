import 'package:flutter/material.dart';

class TechRepairDetailScreen extends StatelessWidget {
  const TechRepairDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails réparation')),
      body: const Center(child: Text('Détails de la réparation')),
    );
  }
}
