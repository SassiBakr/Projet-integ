import 'package:flutter/material.dart';

class OfferManagementScreen extends StatelessWidget {
  const OfferManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des offres')),
      body: const Center(child: Text('Gestion des offres et promotions')),
    );
  }
}
