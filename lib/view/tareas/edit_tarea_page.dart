import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tarea.dart';
import '../../services/database_helper.dart';

class EditTareaPage extends StatefulWidget {
  final Tarea tarea;

  const EditTareaPage({Key? key, required this.tarea}) : super(key: key);

  @override
  _EditTareaPageState createState() => _EditTareaPageState();
}

class _EditTareaPageState extends State<EditTareaPage> {
  late final _formKey = GlobalKey<FormState>();
  late final _tituloController = TextEditingController(
    text: widget.tarea.titulo,
  );
  late final _descripcionController = TextEditingController(
    text: widget.tarea.descripcion,
  );
  late final _nivelController = TextEditingController(
    text: widget.tarea.nivel.toString(),
  );
  late DateTime _fechaEntrega = widget.tarea.fechaEntrega;
  late bool _completada = widget.tarea.completada;
  late String _urgencia = widget.tarea.urgencia;

  final List<String> _urgencias = ['Alta', 'Media', 'Baja'];

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _nivelController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaEntrega,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fechaEntrega) {
      setState(() {
        _fechaEntrega = picked;
      });
    }
  }

  Future<void> _actualizarTarea() async {
    if (_formKey.currentState!.validate()) {
      try {
        final tareaActualizada = Tarea(
          id: widget.tarea.id,
          titulo: _tituloController.text,
          descripcion: _descripcionController.text,
          fechaEntrega: _fechaEntrega,
          nivel: int.parse(_nivelController.text),
          completada: _completada,
          urgencia: _urgencia,
        );

        await Provider.of<DatabaseHelper>(
          context,
          listen: false,
        ).actualizarTarea(tareaActualizada);

        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea actualizada correctamente'),
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
      appBar: AppBar(title: const Text('Editar Tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Fecha de Entrega: ${_fechaEntrega.day}/${_fechaEntrega.month}/${_fechaEntrega.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nivelController,
                decoration: const InputDecoration(
                  labelText: 'Nivel de Dificultad (1-5)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nivel de dificultad';
                  }
                  final nivel = int.tryParse(value);
                  if (nivel == null || nivel < 1 || nivel > 5) {
                    return 'Por favor ingrese un número entre 1 y 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _urgencia,
                items: _urgencias.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _urgencia = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Urgencia',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Completada'),
                value: _completada,
                onChanged: (bool value) {
                  setState(() {
                    _completada = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _actualizarTarea,
                child: const Text('Actualizar Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
