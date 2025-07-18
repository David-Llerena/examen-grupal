import 'package:flutter/material.dart';
import '../../models/desarrollador.dart';

class DesarrolladorTile extends StatelessWidget {
  final Desarrollador desarrollador;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const DesarrolladorTile({
    Key? key,
    required this.desarrollador,
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
                  desarrollador.nombre,
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
            Row(
              children: [
                const Text('Rol: '),
                Chip(
                  label: Text(desarrollador.rol),
                  backgroundColor: Colors.blue[100],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Experiencia: '),
                Text('${desarrollador.experiencia} años'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Disponible: '),
                Icon(
                  desarrollador.disponible
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: desarrollador.disponible ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
