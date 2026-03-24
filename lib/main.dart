import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:med_reminder/alarms/alarm_service.dart';
import 'package:med_reminder/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa awesome_notifications
  await AwesomeNotifications().initialize(
    null, // null = icono por defecto de la app
    [
      NotificationChannel(
        channelKey: 'med_reminder_channel',
        channelName: 'Recordatorios de medicamentos',
        channelDescription: 'Notificaciones para tomar medicamentos',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: true,
        criticalAlerts: true,
      ),
    ],
  );

  // Inicializa el sistema de alarmas
  await AlarmService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
