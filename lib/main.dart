import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/desarrolladores/home_desarrolladores_page.dart';
import 'views/proyectos/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    // Páginas de navegación de la aplicación
    proyectos.HomePage(), // Proyectos
    desarrolladores.HomePage(), // Desarrolladores
    Placeholder(), // Tareas - temporal hasta crear la página
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
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Proyectos'),
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
