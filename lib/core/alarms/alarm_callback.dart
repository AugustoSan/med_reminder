import 'package:alarm/utils/alarm_set.dart';

Future<void> alarmCallback(AlarmSet alarmSet) async {
  
  for( final alarm in alarmSet.alarms) {
    print('sonando: ${alarm.id}  -  ${alarm.notificationSettings.title}');
  }

}