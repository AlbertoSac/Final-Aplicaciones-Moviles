import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'admin_screen.dart';
import 'detalles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CatalogoScreen(),
    );
  }
}

class CatalogoScreen extends StatefulWidget {
  @override
  _CatalogoScreenState createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  List<Map<String, dynamic>> peliculas = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndLoadData();
  }

 Future<void> _initializeFirebaseAndLoadData() async {
  try {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('peliculas');
    DatabaseEvent snapshot = await ref.once();

    if (snapshot.snapshot.value != null) {
      final Object? data = snapshot.snapshot.value;

      setState(() {
        peliculas.addAll((data as Map<dynamic, dynamic>).entries.map<Map<String, dynamic>>((entry) {
          Map<dynamic, dynamic> pelicula = entry.value;
          String peliculaId = entry.key;
          pelicula['id'] = peliculaId; 
          print('ID de la película: $peliculaId');

          return pelicula.cast<String, dynamic>();
        }));
      });
    }
  } catch (error) {
    print('Error al cargar películas desde Firebase: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Películas privado'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                );
              },
              child: Text('Agregar Películas'),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: peliculas.length,
              itemBuilder: (context, index) {
                final pelicula = peliculas[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetallesScreen(pelicula: pelicula, peliculaId: '',),
                      ),
                    );
                  },
                  child: GridTile(
                    child: _buildItem(pelicula),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildItem(Map<dynamic, dynamic> pelicula) {
  String imageUrl = pelicula['imagen'] != null ? pelicula['imagen'].toString() : '';

  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                pelicula['titulo'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              _mostrarConfirmacionEliminar(context, pelicula['id']);
            },
          ),
        ),
      ],
    ),
  );
}

void _mostrarConfirmacionEliminar(BuildContext context, String? peliculaId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmar Eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar esta película?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _eliminarPelicula(peliculaId);
              Navigator.of(context).pop();
            },
            child: Text('Eliminar'),
          ),
        ],
      );
    },
  );
}

void _eliminarPelicula(String? peliculaId) async {
  try {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('peliculas').child(peliculaId!);
    await ref.remove();

    setState(() {
      peliculas.removeWhere((pelicula) => pelicula['id'] == peliculaId);
    });
  } catch (error) {
    print('Error al eliminar película desde Firebase: $error');
  }
}
}