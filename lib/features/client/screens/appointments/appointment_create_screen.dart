import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentCreateScreen extends StatefulWidget {
  const AppointmentCreateScreen({super.key});

  @override
  State<AppointmentCreateScreen> createState() => _AppointmentCreateScreenState();
}

class _AppointmentCreateScreenState extends State<AppointmentCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Rendez-vous'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Détails du rendez-vous',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      
                      // Store selection
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Magasin',
                          prefixIcon: Icon(Icons.store),
                        ),
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('SAV Paris Centre')),
                          DropdownMenuItem(value: '2', child: Text('SAV Lyon')),
                          DropdownMenuItem(value: '3', child: Text('SAV Marseille')),
                        ],
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null) return 'Veuillez sélectionner un magasin';
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Date picker
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Sélectionner une date',
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Time picker
                      InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() => _selectedTime = time);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Heure',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(
                            _selectedTime != null
                                ? '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                : 'Sélectionner une heure',
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Problem description
                      TextFormField(
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description du problème',
                          hintText: 'Décrivez le problème rencontré...',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez décrire le problème';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Get.snackbar(
                      'Succès',
                      'Rendez-vous créé avec succès',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirmer le rendez-vous'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
