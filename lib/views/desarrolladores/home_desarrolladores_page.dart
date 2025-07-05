import 'package:flutter/material.dart';
import 'package:views/edit_desarrollador_page.dart';
import 'package:services/database_service.dart';
import 'package:widgets/desarrollador_tile.dart';

import '../../models/desarrollador.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Desarrollador>> _devList;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _devList = DatabaseService().getDesarrolladores();
    });
  }

  void _deleteDesarrollador(String id) async {
    await DatabaseService().deleteDesarrollador(id);
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipo de Desarrollo'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshList),
        ],
      ),
      body: FutureBuilder<List<Desarrollador>>(
        future: _devList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay desarrolladores registrados'),
            );
          } else {
            return ListView(
              children: snapshot.data!
                  .map(
                    (dev) => DesarrolladorTile(
                      desarrollador: dev,
                      onDelete: () => _deleteDesarrollador(dev.id),
                      onEdit: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditDesarrolladorPage(desarrollador: dev),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) {
            _refreshList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
