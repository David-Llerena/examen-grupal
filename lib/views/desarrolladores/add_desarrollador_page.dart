import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/desarrollador.dart';
import '../../services/database_helper.dart';

class AddDesarrolladorPage extends StatefulWidget {
  const AddDesarrolladorPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddDesarrolladorPageState();
}

class _AddDesarrolladorPageState extends State<AddDesarrolladorPage> {
  final nombreController = TextEditingController();
  final experienciaController = TextEditingController();
  bool _disponible = false;
  String _rolSeleccionado = 'Frontend';

  final List<String> _roles = ['Frontend', 'Backend', 'QA', 'Diseño', 'DevOps'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Desarrollador')),
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
              value: _rolSeleccionado,
              items: _roles
                  .map((rol) => DropdownMenuItem(value: rol, child: Text(rol)))
                  .toList(),
              onChanged: (valor) => setState(() => _rolSeleccionado = valor!),
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
              value: _disponible,
              onChanged: (value) => setState(() => _disponible = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final desarrollador = Desarrollador(
                  id: '',
                  nombre: nombreController.text,
                  rol: _rolSeleccionado,
                  experiencia: int.parse(experienciaController.text),
                  disponible: _disponible,
                );
                await DatabaseHelper().insertDesarrollador(desarrollador);
                Navigator.pop(context, true);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
