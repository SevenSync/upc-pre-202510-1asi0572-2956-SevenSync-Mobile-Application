import 'package:flutter/material.dart';

class RecoveryEmailSentPage extends StatelessWidget {
  const RecoveryEmailSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.account_circle_outlined, size: 80),
                  const SizedBox(height: 30),
                  const Text(
                    "Correo de recuperación enviado",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                        color: Color(0xFF296244)
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Te enviamos una guía para restablecer tu contraseña. Revisa tu bandeja de entrada o la carpeta de spam.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "El enlace tiene una validez de 10 minutos.\nSi no lo recibes o expira, puedes solicitar uno nuevo cada 5 minutos.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),

                  // Botón Regresar
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ECC71),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login'); // ejemplo
                      },
                      child: const Text("Entendido"),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
