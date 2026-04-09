import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:med_reminder/core/alarms/alarm_service.dart';
import 'package:med_reminder/core/constants/app_constants.dart';
import 'package:med_reminder/core/theme/app_theme.dart';
import 'package:med_reminder/presentation/providers/providers.dart';
import 'package:med_reminder/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa awesome_notifications
  await AwesomeNotifications().initialize(
    null, // null = icono por defecto de la app
    [
      NotificationChannel(
        channelKey: AppConstants.notificationChannelKey,
        channelName: AppConstants.notificationChannelName,
        channelDescription: AppConstants.notificationChannelDescription,
        importance: NotificationImportance.Max,
        channelShowBadge: AppConstants.notificationShowBadge,
        playSound: AppConstants.notificationPlaySound,
        criticalAlerts: AppConstants.notificationCriticalAlerts,
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }
}
