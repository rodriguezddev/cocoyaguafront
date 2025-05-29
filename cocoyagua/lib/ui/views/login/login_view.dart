import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../components/inputs/app_input.dart';
import '../../components/buttons/app_button.dart';
import '../../components/layout/app_navbar.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginView({super.key, required this.onLogin});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    final form = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingresa a tu cuenta',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          AppInput(
            label: 'Usuario',
            hintText: 'Usuario',
            controller: _userController,
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Contraseña',
            hintText: 'Contraseña',
            controller: _passwordController,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Iniciar sesión',
            onPressed: () {
              final usuario = _userController.text;
              final contrasena = _passwordController.text;

              if (usuario.isNotEmpty && contrasena.isNotEmpty) {
                widget.onLogin();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Credenciales incorrectas')),
                );
              }
            },
          ),
        ],
      ),
    );

    final image = ClipRRect(
      borderRadius: isWide && kIsWeb
          ? const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            )
          : BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/login_image.png',
        fit: BoxFit.cover,
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          const AppNavbar(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWide ? 1000 : double.infinity,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isWide
                        ? Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: form,
                                  ),
                                ),
                              ),
                              Expanded(child: image),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: 250,
                                      width: double.infinity,
                                      child: image,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.all(38),
                                  child: form,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
