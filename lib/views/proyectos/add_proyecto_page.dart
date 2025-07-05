import 'package:flutter/material.dart';
import 'package:examen_grupal/models/proyecto.dart';
import 'package:examen_grupal/services/database_helper.dart';

class AddProyectoPage extends StatefulWidget {
  const AddProyectoPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddProyectoPageState();
}

class _AddProyectoPageState extends State<AddProyectoPage> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final fechaInicioController = TextEditingController();
  final presupuestoController = TextEditingController();
  bool entregado = false;
  String prioridad = 'Alta';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Proyecto')),
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
              // Campo para la descripción
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
                    initialDate: DateTime.now(),
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
                    // Todo válido, continúa con la lógica
                    final proyecto = Proyecto(
                      id: '',
                      nombre: nombreController.text,
                      descripcion: descripcionController.text,
                      fechaInicio: DateTime.parse(fechaInicioController.text),
                      presupuesto: double.tryParse(presupuestoController.text) ?? 0.0,
                      entregado: entregado,
                      prioridad: prioridad,
                    );
                    await DatabaseHelper().insertProyecto(proyecto);
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
