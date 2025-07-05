import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tarea.dart';
import '../../services/database_helper.dart';
import '../../widgets/tarea_tile.dart';
import 'add_tarea_page.dart';
import 'edit_tarea_page.dart';

class HomeTareasPage extends StatefulWidget {
  const HomeTareasPage({Key? key}) : super(key: key);

  @override
  State<HomeTareasPage> createState() => _HomeTareasPageState();
}

class _HomeTareasPageState extends State<HomeTareasPage> {
  late final DatabaseHelper _db;
  late final Stream<List<Tarea>> _tareasStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _db = Provider.of<DatabaseHelper>(context, listen: false);
    _tareasStream = _db.obtenerTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navegarAAgregar(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Tarea>>(
        stream: _tareasStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tareas = snapshot.data ?? [];

          if (tareas.isEmpty) {
            return const Center(child: Text('No hay tareas registradas'));
          }

          return ListView.builder(
            itemCount: tareas.length,
            itemBuilder: (context, index) {
              final tarea = tareas[index];
              return TareaTile(
                tarea: tarea,
                onEdit: () => _editarTarea(context, tarea),
                onDelete: () => _eliminarTarea(tarea.id!),
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
      MaterialPageRoute(builder: (context) => const AddTareaPage()),
    );
  }

  void _editarTarea(BuildContext context, Tarea tarea) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTareaPage(tarea: tarea)),
    );
  }

  Future<void> _eliminarTarea(String id) async {
    try {
      await _db.eliminarTarea(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea eliminada correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }
}
