import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/proyecto.dart';
import '../../services/database_helper.dart';

class EditProyectoPage extends StatefulWidget {
  final Proyecto proyecto;

  const EditProyectoPage({Key? key, required this.proyecto}) : super(key: key);

  @override
  _EditProyectoPageState createState() => _EditProyectoPageState();
}

class _EditProyectoPageState extends State<EditProyectoPage> {
  late final _formKey = GlobalKey<FormState>();
  late final _nombreController = TextEditingController(
    text: widget.proyecto.nombre,
  );
  late final _descripcionController = TextEditingController(
    text: widget.proyecto.descripcion,
  );
  late final _presupuestoController = TextEditingController(
    text: widget.proyecto.presupuesto.toString(),
  );
  late DateTime _fechaInicio = widget.proyecto.fechaInicio;
  late bool _entregado = widget.proyecto.entregado;
  late String _prioridad = widget.proyecto.prioridad;

  final List<String> _prioridades = ['Alta', 'Media', 'Baja'];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _presupuestoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fechaInicio) {
      setState(() {
        _fechaInicio = picked;
      });
    }
  }

  Future<void> _actualizarProyecto() async {
    if (_formKey.currentState!.validate()) {
      try {
        final proyectoActualizado = Proyecto(
          id: widget.proyecto.id,
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          fechaInicio: _fechaInicio,
          presupuesto: double.parse(_presupuestoController.text),
          entregado: _entregado,
          prioridad: _prioridad,
        );

        await Provider.of<DatabaseHelper>(
          context,
          listen: false,
        ).actualizarProyecto(proyectoActualizado);

        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proyecto actualizado correctamente'),
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
      appBar: AppBar(title: const Text('Editar Proyecto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Proyecto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del proyecto';
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
                      'Fecha de Inicio: ${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year}',
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
                controller: _presupuestoController,
                decoration: const InputDecoration(
                  labelText: 'Presupuesto (en miles de dólares)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el presupuesto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _prioridad,
                items: _prioridades.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _prioridad = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Entregado'),
                value: _entregado,
                onChanged: (bool value) {
                  setState(() {
                    _entregado = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _actualizarProyecto,
                child: const Text('Actualizar Proyecto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
