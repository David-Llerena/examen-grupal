import 'package:flutter/material.dart';
import '../../models/proyecto.dart';

class ProyectoTile extends StatelessWidget {
  final Proyecto proyecto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const ProyectoTile({
    Key? key,
    required this.proyecto,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  proyecto.nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
                    isDeleting
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: onDelete,
                          ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(proyecto.descripcion),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Presupuesto: \$${proyecto.presupuesto.toStringAsFixed(2)}k',
                ),
                Chip(
                  label: Text(proyecto.prioridad),
                  backgroundColor: _getPriorityColor(proyecto.prioridad),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Entregado: '),
                Icon(
                  proyecto.entregado
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: proyecto.entregado ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String prioridad) {
    switch (prioridad) {
      case 'Alta':
        return Colors.red[200]!;
      case 'Media':
        return Colors.orange[200]!;
      case 'Baja':
        return Colors.green[200]!;
      default:
        return Colors.grey[200]!;
    }
  }
}
