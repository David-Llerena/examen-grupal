import 'package:cloud_firestore/cloud_firestore.dart';

class Proyecto {
  String? id;
  final String nombre;
  final String descripcion;
  final DateTime fechaInicio;
  final double presupuesto;
  final bool entregado;
  final String prioridad;

  Proyecto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaInicio,
    required this.presupuesto,
    required this.entregado,
    required this.prioridad,
  });

  factory Proyecto.fromMap(Map<String, dynamic> map, String id) {
    return Proyecto(
      id: id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      fechaInicio: (map['fechaInicio'] as Timestamp).toDate(),
      presupuesto: (map['presupuesto'] as num).toDouble(),
      entregado: map['entregado'] ?? false,
      prioridad: map['prioridad'] ?? 'Media',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaInicio': Timestamp.fromDate(fechaInicio),
      'presupuesto': presupuesto,
      'entregado': entregado,
      'prioridad': prioridad,
    };
  }
}
