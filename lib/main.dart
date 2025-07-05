import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
=======
import 'firebase_options.dart'; // Archivo generado automáticamente
>>>>>>> d1140d5f21fddccb171543c1c5eda38aa08fef61
import 'views/proyectos/home_proyectos_page.dart';
import 'views/desarrolladores/home_desarrolladores_page.dart';
import 'views/tareas/home_tareas_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
  await Firebase.initializeApp();
=======
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
>>>>>>> d1140d5f21fddccb171543c1c5eda38aa08fef61
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Equipos de Desarrollo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
<<<<<<< HEAD
    // aqui se agrega el nombre de las paginas que se van a mostrar dependiendo de lo que pongan los companeros
=======
    //Se agrega el nombre de como esten las pages
>>>>>>> d1140d5f21fddccb171543c1c5eda38aa08fef61
    HomeProyectosPage(),
    HomeDesarrolladoresPage(),
    HomeTareasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Desarrolladores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tareas',
          ),
        ],
      ),
    );
  }
}
