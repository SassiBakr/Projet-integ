import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Administrateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Get.snackbar('Notifications', '5 nouvelles notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec statistiques rapides
            _buildStatsCards(),
            const SizedBox(height: 24),
            
            // Actions rapides
            Text(
              'Actions rapides',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            
            // Activité récente
            Text(
              'Activité récente',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people,
            title: 'Clients',
            value: '1,234',
            color: Colors.blue,
            trend: '+12%',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.engineering,
            title: 'Techniciens',
            value: '45',
            color: Colors.green,
            trend: '+3',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _ActionCard(
          icon: Icons.dashboard,
          title: 'Tableau de bord',
          color: Colors.purple,
          onTap: () => Get.toNamed('/admin/dashboard'),
        ),
        _ActionCard(
          icon: Icons.engineering,
          title: 'Gérer Techniciens',
          color: Colors.orange,
          onTap: () => Get.toNamed('/admin/technicians'),
        ),
        _ActionCard(
          icon: Icons.local_offer,
          title: 'Gérer Offres',
          color: Colors.teal,
          onTap: () => Get.toNamed('/admin/offers'),
        ),
        _ActionCard(
          icon: Icons.bar_chart,
          title: 'Statistiques',
          color: Colors.indigo,
          onTap: () => Get.toNamed('/admin/statistics'),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {'icon': Icons.person_add, 'text': 'Nouveau client inscrit', 'time': 'Il y a 5 min'},
      {'icon': Icons.build, 'text': 'Réparation terminée #1234', 'time': 'Il y a 15 min'},
      {'icon': Icons.calendar_today, 'text': 'Nouveau rendez-vous', 'time': 'Il y a 1h'},
      {'icon': Icons.engineering, 'text': 'Technicien ajouté', 'time': 'Il y a 2h'},
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(activity['icon'] as IconData, color: Colors.blue),
            ),
            title: Text(activity['text'] as String),
            subtitle: Text(activity['time'] as String),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String trend;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 32),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trend,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
