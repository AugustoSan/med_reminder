import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissions {

  static Future<bool> requestAll(BuildContext context) async {
    // Permiso de notificaciones con awesome_notifications
    final notifPermission = await AwesomeNotifications()
        .requestPermissionToSendNotifications();

    // Permiso de alarmas exactas (Android 12+)
    final exactAlarm = await Permission.scheduleExactAlarm.request();

    if (!notifPermission || exactAlarm.isDenied) {
      if (context.mounted) {
        _mostrarDialogo(context);
      }
      return false;
    }

    return true;
  }

  static void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permisos necesarios'),
        content: const Text(
          'Para recibir recordatorios la app necesita '
          'permiso para notificaciones y alarmas exactas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Ir a Configuración'),
          ),
        ],
      ),
    );
  }
}