import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';

mixin SafeDeleteMixin<T extends StatefulWidget> on State<T> {
  bool _isDeleting = false;
  String? _currentDeletingId;

  Future<void> safeDelete({
    required String collection,
    required String id,
    required String successMessage,
  }) async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
      _currentDeletingId = id;
    });

    try {
      final db = Provider.of<DatabaseHelper>(context, listen: false);
      await db.eliminarElemento(collection, id);

      if (!mounted) return;
      _showSnackBar(successMessage);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
          _currentDeletingId = null;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  bool isDeleting(String id) => _isDeleting && _currentDeletingId == id;
}
