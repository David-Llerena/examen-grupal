import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_grupal/models/desarrollador.dart';
import 'package:examen_grupal/models/proyecto.dart';
import 'package:examen_grupal/models/tarea.dart';

class DatabaseHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Colecciones
  static final CollectionReference proyectosCollection = _firestore.collection(
    'proyectos',
  );
  static final CollectionReference desarrolladoresCollection = _firestore
      .collection('desarrolladores');
  static final CollectionReference tareasCollection = _firestore.collection(
    'tareas',
  );

  // ======================= PROYECTOS =======================
  Future<void> insertProyecto(Proyecto proyecto) async {
    await proyectosCollection.add(proyecto.toMap());
  }

  Future<List<Proyecto>> getProyectos() async {
    final snapshot = await proyectosCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Proyecto(
        id: doc.id,
        nombre: data["nombre"] ?? "",
        descripcion: data["descripcion"] ?? "",
        fechaInicio: data["fechaInicio"] ?? "",
        presupuesto: data["presupuesto"] ?? "",
        entregado: data["entregado"] ?? "",
        prioridad: data["prioridad"] ?? "",
      );
    }).toList();
  }

  Future<void> updateProyecto(Proyecto proyecto) async {
    await proyectosCollection.doc(proyecto.id).update(proyecto.toMap());
  }

  Future<void> deleteProyecto(String id) async {
    await proyectosCollection.doc(id).delete();
  }

  // ======================= DESARROLLADORES =======================
  Future<void> insertDesarrollador(Desarrollador desarrollador) async {
    await desarrolladoresCollection.add(desarrollador.toMap());
  }

  Future<List<Desarrollador>> getDesarrolladores() async {
    final snapshot = await desarrolladoresCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Desarrollador(
        id: doc.id,
        nombre: data["nombre"] ?? "",
        rol: data["rol"] ?? "",
        experiencia: data["experiencia"] ?? "",
        disponible: data["disponible"] ?? "",
      );
    }).toList();
  }

  Future<void> updateDesarrollador(Desarrollador desarrollador) async {
    await desarrolladoresCollection
        .doc(desarrollador.id)
        .update(desarrollador.toMap());
  }

  Future<void> deleteDesarrollador(String id) async {
    await desarrolladoresCollection.doc(id).delete();
  }

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
}
