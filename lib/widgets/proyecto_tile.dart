import 'package:examen_grupal/models/proyecto.dart';
import 'package:flutter/material.dart';

class ProyectoTile extends StatelessWidget {
  final Proyecto proyecto;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProyectoTile({
    super.key,
    required this.proyecto,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(proyecto.nombre),
        subtitle: Text("${proyecto.presupuesto} - ${proyecto.prioridad}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              proyecto.entregado ? Icons.check_circle : Icons.check_circle_outline,
              color: proyecto.entregado ? Colors.green : Colors.grey,
            ),
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
