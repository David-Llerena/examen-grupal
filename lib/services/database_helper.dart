import 'package:examen_grupal/models/tarea.dart';

class DatabaseHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // ======================= TAREAS =======================
  Future<void> insertTarea(Tarea tarea) async {
    await tareasCollection.add(tarea.toMap());
  }

  Future<List<Tarea>> getTareas() async {
    final snapshot = await tareasCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Tarea(
        id: doc.id,
        titulo: data['titulo'] ?? '',
        descripcion: data['descripcion'] ?? '',
        fechaEntrega: data['fechaEntrega'] ?? '',
        nivel: data['nivel'] ?? '',
        completada: data['completada'] ?? '',
        urgencia: data['urgencia'] ?? '',
      );
    }).toList();
  }

  Future<void> updateTarea(Tarea tarea) async {
    await tareasCollection.doc(tarea.id).update(tarea.toMap());
  }

  Future<void> deleteTarea(String id) async {
    await tareasCollection.doc(id).delete();
  }