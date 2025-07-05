import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:prueba/view/desarrolladores/home_desarrolladores_page.dart';
import 'package:prueba/view/proyectos/home_proyecto_page.dart';
import 'package:prueba/view/tareas/home_tarea_page.dart';
import 'services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DatabaseHelper(),
      child: MaterialApp(
        title: 'Gestión de Equipos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeProyectosPage(),
    const HomeDesarrolladoresPage(),
    const HomeTareasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Desarrolladores',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tareas'),
        ],
      ),
    );
  }
}
