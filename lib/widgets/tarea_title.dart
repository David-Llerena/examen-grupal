import '../models/tarea.dart';

class Tarea_Title extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const Tarea_Title({
    super.key,
    required this.tarea,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(tarea.titulo),
        subtitle: Text("${tarea.nivel} - ${tarea.urgencia}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tarea.completada ? Icons.check_circle : Icons.check_circle_outline,
              color: tarea.completada ? Colors.green : Colors.grey,
            ),
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}