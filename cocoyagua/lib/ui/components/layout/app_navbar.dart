import 'package:flutter/material.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Image.asset('assets/images/logo.png',
                  height: 28), // Asegúrate de tener este logo
              
            ],
          ),
          const Spacer(),
          // Menú (escondido en móvil)
          if (!isMobile)
            Row(
              children: [
                _navItem('Servicios'),
                _navItem('Planes de pago'),
                _navItem('Tarifas'),
                _navItem('Medidores'),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF36B7D7),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text('Iniciar sesión'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF36B7D7),
                    side: const BorderSide(color: Color(0xFF36B7D7)),
                  ),
                  child: const Text('Crear una cuenta'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }
}
