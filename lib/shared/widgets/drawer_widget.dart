import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                    context,
                    icon: Icons.home_outlined,
                    title: 'Início',
                    onTap: () => Modular.to.navigate('/home/'),
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.event_outlined,
                    title: 'Eventos',
                    onTap: () => Modular.to.navigate('/home/'),
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.place_outlined,
                    title: 'Locais',
                    onTap: () => Modular.to.navigate('/home/'),
                  ),

                  const Divider(),

                  _drawerItem(
                    context,
                    icon: Icons.add_circle_outline,
                    title: 'Novo Evento',
                    onTap: () => Modular.to.pushNamed('/events/create'),
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.add_location_alt_outlined,
                    title: 'Novo Local',
                    onTap: () => Modular.to.pushNamed('/places/create'),
                  ),

                  const Divider(),

                  _drawerItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Configurações',
                    onTap: () {},
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Ajuda',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 38, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            'Mary Soarez',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('mary@email.com', style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
