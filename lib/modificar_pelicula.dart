import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ModificarPeliculaScreen extends StatefulWidget {
  final Map<dynamic, dynamic> pelicula;

  ModificarPeliculaScreen({required this.pelicula});

  @override
  _ModificarPeliculaScreenState createState() => _ModificarPeliculaScreenState();
}

class _ModificarPeliculaScreenState extends State<ModificarPeliculaScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _sinopsisController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.pelicula['titulo'];
    _anioController.text = widget.pelicula['anio'];
    _directorController.text = widget.pelicula['director'];
    _generoController.text = widget.pelicula['genero'];
    _sinopsisController.text = widget.pelicula['sinopsis'];
  }

Future<void> _modificarPelicula() async {
  try {
    String nuevoTitulo = _tituloController.text;
    String nuevoAnio = _anioController.text;
    String nuevoDirector = _directorController.text;
    String nuevoGenero = _generoController.text;
    String nuevaSinopsis = _sinopsisController.text;

    String peliculaId = widget.pelicula['id'];
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('peliculas').child(peliculaId);
    
    await ref.update({
      'titulo': nuevoTitulo,
      'anio': nuevoAnio,
      'director': nuevoDirector,
      'genero': nuevoGenero,
      'sinopsis': nuevaSinopsis,
    });

    showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Éxito'),
      content: Text('La película ha sido modificada correctamente.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop({'actualizado': true});
          },
          child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  } catch (error) {
    print('Error al modificar la película: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Película'),
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _modificarPelicula,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
