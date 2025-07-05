import 'package:flutter/material.dart';
import '../../models/tarea.dart';

class TareaTile extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const TareaTile({
    Key? key,
    required this.tarea,
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
                  tarea.titulo,
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
            Text(tarea.descripcion),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nivel: ${'⭐' * tarea.nivel}${'☆' * (5 - tarea.nivel)}'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getUrgencyColor(tarea.urgencia),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tarea.urgencia,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Entrega: ${_formatDate(tarea.fechaEntrega)}'),
                Row(
                  children: [
                    const Text('Completada: '),
                    Icon(
                      tarea.completada
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: tarea.completada ? Colors.green : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgencia) {
    switch (urgencia) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
