class AppConstants {
  // App Information
  static const String appName = 'Med Reminder';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplicación para recordar la toma de medicamentos.';
  static const String appAuthor = 'Augusto Sánchez';

  // Database
  static const String databaseName = 'med_reminder.db';
  static const int databaseVersion = 1;
  static const String medicationTable = 'medications';
  static const String scheduleTable = 'medication_schedules';
  static const String historyTable = 'medication_histories';

  // Notification Channel
  static const String notificationChannelKey = 'med_reminder_channel';
  static const String notificationChannelName = 'Recordatorios de medicamentos';
  static const String notificationChannelDescription = 'Notificaciones para tomar medicamentos';
  static const bool notificationShowBadge = true;
  static const bool notificationPlaySound = true;
  static const bool notificationCriticalAlerts = true;

  // Alarm Settings
  static const String alarmAudioPath = 'assets/sounds/alarms/Ripple.ogg';
  static const bool alarmLoopAudio = true;
  static const bool alarmVibrate = true;
  static const int alarmSnoozeMinutes = 10;
  
}