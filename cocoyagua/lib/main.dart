import 'package:cocoyagua/ui/views/contratos/contratos_view.dart';
import 'package:cocoyagua/ui/views/lecturas/lecturas_view.dart';
import 'package:cocoyagua/ui/views/pedidos/pedidos_view.dart';
import 'package:cocoyagua/ui/views/personas/personas_view.dart';
import 'package:cocoyagua/ui/views/solicitudes/solicitudes_view.dart';
import 'package:cocoyagua/ui/views/titular/titulares_view.dart';
import 'package:flutter/material.dart';
import 'package:cocoyagua/ui/theme/app_theme.dart';
import 'package:cocoyagua/ui/views/login/login_view.dart';
import 'package:cocoyagua/ui/views/dashboard/dashboard_view.dart';
import 'package:cocoyagua/ui/views/tomas_domiciliarias/tomas_domiciliarias_view.dart';
import 'package:cocoyagua/ui/views/productos_servicios/productos_servicios_view.dart'; // Importar la nueva vista

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  void handleLogin() {
    setState(() => isLoggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocoyagua',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home:
          isLoggedIn ? const DashboardView() : LoginView(onLogin: handleLogin),
      routes: {
        '/dashboard': (_) => const DashboardView(),
        '/gestion/personas': (context) => const PersonasView(),
        '/configuracion/region': (_) => const DummyPage('Región'),
        '/configuracion/empresa': (_) => const DummyPage('Empresa'),
        '/gestion/productos_servicios': (_) => const ProductosServiciosView(), // Ruta para Productos y Servicios
        '/gestion/clientes': (_) => const DummyPage('Clientes'),
        '/gestion&saneamiento/tomas_domiciliarias': (_) => const TomasDomiciliariasView(),
        '/gestion&saneamiento/solicitudes': (_) => const SolicitudesView(),
        '/gestion&saneamiento/titulares': (_) => const TitularesView(), 
        '/gestion&saneamiento/contratos': (_) => const ContratosView(), 
        '/facturacion/lecturas-medidores': (_) => const LecturasView(), 
        '/facturacion/pedidos': (_) => const PedidosView(), // Ruta para el nuevo módulo de Pedidos
        '/bitacora': (_) => const DummyPage('Bitácora'),
        
      },
    );
  }
}

class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Contenido de $title')),
    );
  }
}
