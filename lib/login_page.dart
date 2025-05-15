import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:reportes_medired/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Función para hashear la contraseña
String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convierte la contraseña en bytes
  final hash = sha256.convert(bytes); // Hashea la contraseña
  return hash.toString();
}

// Función para verificar la contraseña
bool verifyPassword(String password, String hashedPassword) {
  return hashPassword(password) == hashedPassword;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variable para controlar si la contraseña es visible o no
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    final user = _userController.text.trim();
    final password = _passwordController.text.trim();
    final hashedPassword = hashPassword(password);

    final doc = await _firestore.collection('admin_account').doc(user).get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null && verifyPassword(password, data['password'])) {
        // Inicio de sesión exitoso
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("login","1");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else {
        // Contraseña incorrecta
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    } else {
      // Usuario no encontrado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen decorativa
                Expanded(
                  child: Image.asset(
                    'assets/images/logo.png', // Asegúrate de agregar esta imagen en el folder assets.
                    height: 400,
                  ),
                ),
                // Formulario de inicio de sesión
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text(
                        //   'Inicio ',
                        //   style: TextStyle(
                        //     fontSize: 36.0,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   'Bienvenido de nuevo',
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     color: Colors.grey[700],
                        //   ),
                        // ),
                        const SizedBox(height: 32),
                        // Campo de Usuario
                        TextField(
                          controller: _userController,
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Campo de Contraseña
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        // Botón de Login
                        Center(
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFB1BF49), // Verde del logo
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 50), // Ajusta el tamaño
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 20, // Aumenta el tamaño de la fuente
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text(
                              'Acceder',
                              style: TextStyle(
                                color: Color(0xFF26499A), // Azul del logo
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        // Link para registro
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
