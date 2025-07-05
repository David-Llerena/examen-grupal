import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/proyecto.dart';
import '../../services/database_helper.dart';
import '../../widgets/proyecto_tile.dart';
import 'add_proyecto_page.dart';
import 'edit_proyecto_page.dart';

class HomeProyectosPage extends StatefulWidget {
  const HomeProyectosPage({Key? key}) : super(key: key);

  @override
  State<HomeProyectosPage> createState() => _HomeProyectosPageState();
}

class _HomeProyectosPageState extends State<HomeProyectosPage> {
  late final DatabaseHelper _db;
  late final Stream<List<Proyecto>> _proyectosStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _db = Provider.of<DatabaseHelper>(context, listen: false);
    _proyectosStream = _db.obtenerProyectos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navegarAAgregar(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Proyecto>>(
        stream: _proyectosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final proyectos = snapshot.data ?? [];

          if (proyectos.isEmpty) {
            return const Center(child: Text('No hay proyectos registrados'));
          }

          return ListView.builder(
            itemCount: proyectos.length,
            itemBuilder: (context, index) {
              final proyecto = proyectos[index];
              return ProyectoTile(
                proyecto: proyecto,
                onEdit: () => _editarProyecto(context, proyecto),
                onDelete: () => _eliminarProyecto(proyecto.id!),
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
      MaterialPageRoute(builder: (context) => const AddProyectoPage()),
    );
  }

  void _editarProyecto(BuildContext context, Proyecto proyecto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProyectoPage(proyecto: proyecto),
      ),
    );
  }

  Future<void> _eliminarProyecto(String id) async {
    try {
      await _db.eliminarProyecto(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proyecto eliminado correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }
}
