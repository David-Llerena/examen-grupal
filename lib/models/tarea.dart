class Tarea {
  String? id;
  final String titulo;
  final String descripcion;
  final DateTime fechaEntrega;
  final int nivel;
  final bool completada;
  final String urgencia;

  Tarea({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaEntrega,
    required this.nivel,
    required this.completada,
    required this.urgencia,
  });

  factory Tarea.fromMap(Map<String, dynamic> map, String id) {
    return Tarea(
      id: id,
      titulo: map['titulo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      fechaEntrega: (map['fechaEntrega'] as Timestamp).toDate(),
      nivel: map['nivel'] ?? 1,
      completada: map['completada'] ?? false,
      urgencia: map['urgencia'] ?? 'Media',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fechaEntrega': Timestamp.fromDate(fechaEntrega),
      'nivel': nivel,
      'completada': completada,
      'urgencia': urgencia,
    };
  }
}
