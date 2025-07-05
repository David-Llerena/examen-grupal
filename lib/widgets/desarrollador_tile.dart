import '../models/desarrollador.dart';

class DesarrolladorTile extends StatelessWidget {
  final Desarrollador desarrollador;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const DesarrolladorTile({
    super.key,
    required this.desarrollador,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(desarrollador.nombre),
        subtitle: Text("${desarrollador.rol} - ${desarrollador.experiencia}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              desarrollador.disponible ? Icons.check_circle : Icons.check_circle_outline,
              color: desarrollador.disponible ? Colors.green : Colors.grey,
            ),
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
