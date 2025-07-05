import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/desarrollador.dart';
import '../../services/database_helper.dart';
import '../../widgets/desarrollador_tile.dart';
import 'add_desarrollador_page.dart';
import 'edit_desarrollador_page.dart';

class HomeDesarrolladoresPage extends StatefulWidget {
  const HomeDesarrolladoresPage({super.key});

  @override
  State<HomeDesarrolladoresPage> createState() =>
      _HomeDesarrolladoresPageState();
}

class _HomeDesarrolladoresPageState extends State<HomeDesarrolladoresPage> {
  late final DatabaseHelper _db;
  late final Stream<List<Desarrollador>> _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _db = Provider.of<DatabaseHelper>(context, listen: false);
    _stream = _db.obtenerDesarrolladores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desarrolladores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navegarAAgregar(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Desarrollador>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final desarrolladores = snapshot.data ?? [];

          if (desarrolladores.isEmpty) {
            return const Center(
              child: Text('No hay desarrolladores registrados'),
            );
          }

          return ListView.builder(
            itemCount: desarrolladores.length,
            itemBuilder: (context, index) {
              final desarrollador = desarrolladores[index];
              return DesarrolladorTile(
                desarrollador: desarrollador,
                onEdit: () => _editarDesarrollador(context, desarrollador),
                onDelete: () => _eliminarDesarrollador(desarrollador.id!),
              );
            },
          );
        },
      ),
    );
  }

  void _navegarAAgregar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDesarrolladorPage()),
    );
  }

  void _editarDesarrollador(BuildContext context, Desarrollador desarrollador) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditDesarrolladorPage(desarrollador: desarrollador),
      ),
    );
  }

  Future<void> _eliminarDesarrollador(String id) async {
    try {
      await _db.eliminarDesarrollador(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Desarrollador eliminado correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }
}
