import 'package:flutter/material.dart';
import 'package:examen_grupal/models/proyecto.dart';  
import 'package:examen_grupal/services/database_helper.dart';

class EditProyectoPage extends StatefulWidget {
  final Proyecto proyecto;

  const EditProyectoPage({super.key, required this.proyecto});

  @override
  State<StatefulWidget> createState() => _EditProyectoPageState();
}

class _EditProyectoPageState extends State<EditProyectoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController fechaInicioController;
  late TextEditingController presupuestoController;
  late bool entregado;
  late String prioridad;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.proyecto.nombre);
    descripcionController = TextEditingController(text: widget.proyecto.descripcion);
    fechaInicioController = TextEditingController(text: widget.proyecto.fechaInicio);
    presupuestoController = TextEditingController(text: widget.proyecto.presupuesto.toString());
    entregado = widget.proyecto.entregado;
    prioridad = widget.proyecto.prioridad;
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    fechaInicioController.dispose();
    presupuestoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Proyecto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del Proyecto'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              TextFormField(
                controller: fechaInicioController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Inicio',
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La fecha de inicio es obligatoria';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(fechaInicioController.text),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    setState(() {
                      fechaInicioController.text = formattedDate;
                    });
                  }
                },
              ),
              TextFormField(
                controller: presupuestoController,
                decoration: const InputDecoration(labelText: 'Presupuesto'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El presupuesto es obligatorio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un valor numérico válido';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  const Text('Entregado'),
                  Checkbox(
                    value: entregado,
                    onChanged: (value) {
                      setState(() {
                        entregado = value!;
                      });
                    },
                  ),
                ],
              ),
              DropdownButton<String>(
                value: prioridad,
                items: ['Alta', 'Media', 'Baja']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => prioridad = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final proyectoActualizado = Proyecto(
                      id: widget.proyecto.id,
                      nombre: nombreController.text,
                      descripcion: descripcionController.text,
                      fechaInicio: fechaInicioController.text,
                      presupuesto: double.tryParse(presupuestoController.text) ?? 0.0,
                      entregado: entregado,
                      prioridad: prioridad,
                    );
                    await DatabaseHelper().updateProyecto(proyectoActualizado);
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
