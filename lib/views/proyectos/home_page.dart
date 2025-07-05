import 'package:flutter/material.dart';
import 'package:examen_grupal/models/proyecto.dart';
import 'package:examen_grupal/services/database_helper.dart';
import 'package:examen_grupal/views/proyectos/edit_proyecto_page.dart';
import 'package:examen_grupal/widgets/proyecto_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Proyecto>> _proyectoList;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _proyectoList = DatabaseHelper().getProyectos();
    });
  }

  void _deleteProyecto(String? id) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este proyecto?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await DatabaseHelper().deleteProyecto(id);
                _refreshList();
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Proyecto App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Proyecto>>(
              future: _proyectoList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay proyectos encontrados.'),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!
                        .map(
                          (proyecto) => ProyectoTile(
                            proyecto: proyecto,
                            onDelete: () => _deleteProyecto(proyecto.id),
                            onEdit: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditProyectoPage(proyecto: proyecto),
                                ),
                              );
                              if (result == true) {
                                _refreshList();
                              }
                            },
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, 'addProyecto');
          if (result == true) {
            _refreshList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
