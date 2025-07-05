import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/desarrollador.dart';
import '../../services/database_helper.dart';

class EditDesarrolladorPage extends StatefulWidget {
  final Desarrollador desarrollador;

  const EditDesarrolladorPage({super.key, required this.desarrollador});

  @override
  _EditDesarrolladorPageState createState() => _EditDesarrolladorPageState();
}

class _EditDesarrolladorPageState extends State<EditDesarrolladorPage> {
  late final _formKey = GlobalKey<FormState>();
  late final _nombreController = TextEditingController(
    text: widget.desarrollador.nombre,
  );
  late final _experienciaController = TextEditingController(
    text: widget.desarrollador.experiencia.toString(),
  );
  late String _rol = widget.desarrollador.rol;
  late bool _disponible = widget.desarrollador.disponible;

  final List<String> _roles = ['Frontend', 'Backend', 'QA', 'Diseño', 'DevOps'];

  @override
  void dispose() {
    _nombreController.dispose();
    _experienciaController.dispose();
    super.dispose();
  }

  Future<void> _actualizarDesarrollador() async {
    if (_formKey.currentState!.validate()) {
      try {
        final desarrolladorActualizado = Desarrollador(
          id: widget.desarrollador.id,
          nombre: _nombreController.text,
          rol: _rol,
          experiencia: int.parse(_experienciaController.text),
          disponible: _disponible,
        );

        await Provider.of<DatabaseHelper>(
          context,
          listen: false,
        ).actualizarDesarrollador(desarrolladorActualizado);

        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Desarrollador actualizado correctamente'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Desarrollador')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _rol,
                items: _roles.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _rol = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienciaController,
                decoration: const InputDecoration(
                  labelText: 'Años de Experiencia',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los años de experiencia';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Disponible'),
                value: _disponible,
                onChanged: (bool value) {
                  setState(() {
                    _disponible = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _actualizarDesarrollador,
                child: const Text('Actualizar Desarrollador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
