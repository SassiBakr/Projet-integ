import 'package:flutter/material.dart';

// Placeholder screens - to be implemented

class AppointmentListScreen extends StatelessWidget {
  const AppointmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Rendez-vous')),
      body: const Center(child: Text('Liste des rendez-vous')),
    );
  }
}
