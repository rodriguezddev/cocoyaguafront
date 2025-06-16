import 'package:flutter/material.dart';
import '../../components/inputs/app_input.dart';
import '../../components/buttons/app_button.dart';
import '../../components/layout/app_navbar.dart'; // Reutilizamos el Navbar si es apropiado
import '../../theme/app_theme.dart'; // Para colores y estilos
import '../../theme/spacing.dart';   // Para espaciado
import '../../theme/typography.dart'; // Para estilos de texto

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendRecoveryLink() {
    if (_formKey.currentState!.validate()) {
      // Aquí iría la lógica para llamar a un backend y enviar el correo.
      // Por ahora, simulamos el envío.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Se ha enviado un enlace de recuperación a ${_emailController.text}. Revisa tu bandeja de entrada para continuar en la web.'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      // Opcionalmente, podrías navegar de vuelta al login después de un delay
      // Future.delayed(const Duration(seconds: 3), () {
      //   if (mounted) Navigator.pop(context);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppNavbar(), // O un AppBar simple si prefieres
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recuperar Contraseña',
                          style: AppTypography.h1.copyWith(color: AppTheme.textPrimaryColor),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
                          style: AppTypography.bodyLg.copyWith(color: AppTheme.textPrimaryColor),
                        ),
                        const SizedBox(height: Spacing.xl),
                        AppInput(
                          label: 'Correo Electrónico',
                          hintText: 'tu.correo@ejemplo.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu correo.';
                            }
                            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                              return 'Ingresa un correo válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Spacing.lg),
                        AppButton(
                          text: 'Enviar Enlace de Recuperación',
                          width: double.infinity,
                          onPressed: _sendRecoveryLink,
                        ),
                        const SizedBox(height: Spacing.md),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Volver a la pantalla de Login
                            },
                            child: const Text('Volver al inicio de sesión'),
                          ),
                        ),
                      ],
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