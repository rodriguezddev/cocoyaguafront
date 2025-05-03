import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile ? const Drawer(child: _Sidebar()) : null,
      body: Row(
        children: [
          if (!isMobile) const _Sidebar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: const Center(
                child: Text('Aquí va el contenido del dashboard'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blue[50],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('Dashboard'),
            leading: Icon(Icons.dashboard),
          ),
          ListTile(
            title: Text('Usuarios'),
            leading: Icon(Icons.people),
          ),
          ListTile(
            title: Text('Medidores'),
            leading: Icon(Icons.speed),
          ),
          ListTile(
            title: Text('Configuración'),
            leading: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
