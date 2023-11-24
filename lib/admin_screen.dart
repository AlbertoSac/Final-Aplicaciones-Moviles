import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'catalogo.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminScreen(),
    );
  }
}

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _sinopsisController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();

  void _limpiarControladores() {
    _tituloController.clear();
    _anioController.clear();
    _directorController.clear();
    _generoController.clear();
    _sinopsisController.clear();
    _imagenController.clear();
  }

  Future<void> _altaPelicula() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuario no autenticado. Por favor, inicia sesión.');
      return;
    }
    String uid = user.uid;

    if (_tituloController.text.isEmpty || _anioController.text.isEmpty) {
      print('Título y Año son campos obligatorios.');
      return;
    }

    DatabaseReference peliculasRef = FirebaseDatabase.instance.ref().child('peliculas');
    DatabaseReference nuevaPeliculaRef = peliculasRef.push();
    String peliculaId = nuevaPeliculaRef.key!;

    await nuevaPeliculaRef.set({
      'titulo': _tituloController.text,
      'anio': _anioController.text,
      'director': _directorController.text,
      'genero': _generoController.text,
      'sinopsis': _sinopsisController.text,
      'imagen': _imagenController.text,
      'usuario_id': uid,
    });

    _limpiarControladores();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Película dada de alta con éxito. ID: $peliculaId'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );

      Navigator.popUntil(context, ModalRoute.withName('/catalogo'));
  } catch (error) {
    print('Error al dar de alta la película: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar películas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _anioController,
              decoration: InputDecoration(labelText: 'Año'),
            ),
            TextField(
              controller: _directorController,
              decoration: InputDecoration(labelText: 'Director'),
            ),
            TextField(
              controller: _generoController,
              decoration: InputDecoration(labelText: 'Género'),
            ),
            TextField(
              controller: _sinopsisController,
              decoration: InputDecoration(labelText: 'Sinopsis'),
            ),
            TextField(
              controller: _imagenController,
              decoration: InputDecoration(labelText: 'Imagen URL'),
            ),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _altaPelicula,
              child: Text('Dar de alta película'),
            ),
          ],
        ),
      ),
    );
  }
}
