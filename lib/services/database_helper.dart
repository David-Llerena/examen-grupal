import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/desarrollador.dart';
import '../models/proyecto.dart';
import '../models/tarea.dart';

class DatabaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Colecciones
  CollectionReference get desarrolladores =>
      _firestore.collection('desarrolladores');
  CollectionReference get proyectos => _firestore.collection('proyectos');
  CollectionReference get tareas => _firestore.collection('tareas');

  // Métodos para Desarrolladores
  Future<void> agregarDesarrollador(Desarrollador desarrollador) async {
    await desarrolladores.add(desarrollador.toMap());
  }

  Future<void> actualizarDesarrollador(Desarrollador desarrollador) async {
    await desarrolladores.doc(desarrollador.id).update(desarrollador.toMap());
  }

  Future<void> eliminarDesarrollador(String id) async {
    await desarrolladores.doc(id).delete();
  }

  Stream<List<Desarrollador>> obtenerDesarrolladores() {
    return desarrolladores.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Desarrollador.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Métodos para Proyectos
  Future<void> agregarProyecto(Proyecto proyecto) async {
    await proyectos.add(proyecto.toMap());
  }

  Future<void> actualizarProyecto(Proyecto proyecto) async {
    await proyectos.doc(proyecto.id).update(proyecto.toMap());
  }

  Future<void> eliminarProyecto(String id) async {
    await proyectos.doc(id).delete();
  }

  Stream<List<Proyecto>> obtenerProyectos() {
    return proyectos.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Proyecto.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Métodos para Tareas
  Future<void> agregarTarea(Tarea tarea) async {
    await tareas.add(tarea.toMap());
  }

  Future<void> actualizarTarea(Tarea tarea) async {
    await tareas.doc(tarea.id).update(tarea.toMap());
  }

  Future<void> eliminarTarea(String id) async {
    await tareas.doc(id).delete();
  }

  Stream<List<Tarea>> obtenerTareas() {
    return tareas.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Tarea.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
