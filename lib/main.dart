import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'inicio.dart';
import 'registro.dart';
import 'inicio_sesion.dart';
import 'catalogo.dart';
import 'detalles.dart';
import 'admin_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBi9ZZPgsGnP8MtZetBM3Cvb8-VWGxdssw',
      appId: '1:479114327571:android:0c7d3cbbb6fc18ea5a31e6',
      messagingSenderId: '479114327571',
      projectId: 'integradora-942d6',
      databaseURL: 'https://integradora-942d6-default-rtdb.firebaseio.com/',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tu Aplicación',
      initialRoute: '/',
      routes: {
        '/': (context) => InicioScreen(),
        '/registro': (context) => RegistroScreen(),
        '/inicio_sesion': (context) => InicioSesionScreen(),
        '/catalogo': (context) => CatalogoScreen(),
        '/detalles': (context) => DetallesScreen(pelicula: {}, peliculaId: ''),
        '/admin': (context) => AdminScreen(),
      },
    );
  }
}