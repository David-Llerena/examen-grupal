import 'package:flutter/material.dart';
import '../../models/desarrollador.dart';
import '../services/database_service.dart';

class EditDesarrolladorPage extends StatefulWidget {
  final Desarrollador desarrollador;

  const EditDesarrolladorPage({super.key, required this.desarrollador});

  @override
  State<EditDesarrolladorPage> createState() => _EditDesarrolladorPageState();
}

class _EditDesarrolladorPageState extends State<EditDesarrolladorPage> {
  late TextEditingController nombreController;
  late TextEditingController experienciaController;
  late String rolSeleccionado;
  late bool disponible;

  final List<String> _roles = ['Frontend', 'Backend', 'QA', 'Diseño', 'DevOps'];

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.desarrollador.nombre);
    experienciaController = TextEditingController(
      text: widget.desarrollador.experiencia.toString(),
    );
    rolSeleccionado = widget.desarrollador.rol;
    disponible = widget.desarrollador.disponible;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Desarrollador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: rolSeleccionado,
              items: _roles
                  .map((rol) => DropdownMenuItem(value: rol, child: Text(rol)))
                  .toList(),
              onChanged: (valor) => setState(() => rolSeleccionado = valor!),
              decoration: const InputDecoration(labelText: 'Rol'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: experienciaController,
              decoration: const InputDecoration(
                labelText: 'Años de experiencia',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('¿Disponible?'),
              value: disponible,
              onChanged: (value) => setState(() => disponible = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final actualizado = Desarrollador(
                  id: widget.desarrollador.id,
                  nombre: nombreController.text,
                  rol: rolSeleccionado,
                  experiencia: int.parse(experienciaController.text),
                  disponible: disponible,
                );
                await DatabaseService().updateDesarrollador(actualizado);
                Navigator.pop(context, true);
              },
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
