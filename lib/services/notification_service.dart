import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Inicializa o serviço de notificações
  static Future<void> initialize() async {
    // Configura a biblioteca de timezone
    tz.initializeTimeZones();
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// Converte DateTime para TZDateTime
  static tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    final location = tz.getLocation('America/Sao_Paulo'); // Ajuste conforme necessário
    return tz.TZDateTime.from(dateTime, location);
  }

  /// Agenda uma notificação local
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'astronomy_channel',
      'Astronomy Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _convertToTZDateTime(dateTime), // Converte para TZDateTime
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
