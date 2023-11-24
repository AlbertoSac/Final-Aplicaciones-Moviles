import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido a nuestro catalogo, necesitas registrarte!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/registro');
            },
              child: Text('Registrarse'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/inicio_sesion');
            },
            child: Text('Iniciar Sesión'),
          ),
          ],
        ),
      ),
    );
  }
}
