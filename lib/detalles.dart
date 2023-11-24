import 'package:flutter/material.dart';
import 'modificar_pelicula.dart'; 

class DetallesScreen extends StatelessWidget {
  final Map<String, dynamic> pelicula;
  final String? peliculaId;

  const DetallesScreen({required this.pelicula, required this.peliculaId});

  @override
  Widget build(BuildContext context) {
    print('ID de la película en DetallesScreen: $peliculaId');

    return Scaffold(
      appBar: AppBar(
        title: Text(pelicula['titulo'] ?? 'Detalles de la Película'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            pelicula['imagen'] != null
                ? Image.network(
                    pelicula['imagen'],
                    fit: BoxFit.cover,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 16.0),
            Text(
              'Título: ${pelicula['titulo'] ?? ''}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Año: ${pelicula['anio'] ?? ''}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Director: ${pelicula['director'] ?? ''}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Género: ${pelicula['genero'] ?? ''}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Sinopsis: ${pelicula['sinopsis'] ?? ''}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModificarPeliculaScreen(
                      pelicula: pelicula,
                    ),
                  ),
                );
              },
              child: Text('Modificar Película'),
            ),
          ],
        ),
      ),
    );
  }
}
