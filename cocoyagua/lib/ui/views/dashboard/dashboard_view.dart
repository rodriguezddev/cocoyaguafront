import 'package:flutter/material.dart';
import 'package:cocoyagua/ui/widgets/sidebar_menu.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile ? const Drawer(child: SidebarMenu()) : null,
      body: Row(
        children: [
          if (!isMobile) const SidebarMenu(),
          const Expanded(
            child: Center(child: Text('Aquí va el contenido del dashboard')),
          ),
        ],
      ),
    );
  }
}
