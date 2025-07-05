class Desarrollador {
  String? id;
  final String nombre;
  final String rol;
  final int experiencia;
  final bool disponible;

  Desarrollador({
    this.id,
    required this.nombre,
    required this.rol,
    required this.experiencia,
    required this.disponible,
  });

  factory Desarrollador.fromMap(Map<String, dynamic> map, String id) {
    return Desarrollador(
      id: id,
      nombre: map['nombre'] ?? '',
      rol: map['rol'] ?? 'Frontend',
      experiencia: map['experiencia'] ?? 0,
      disponible: map['disponible'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'rol': rol,
      'experiencia': experiencia,
      'disponible': disponible,
    };
  }
}
