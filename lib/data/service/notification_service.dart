import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const String channelId = 'daily_quotes';
  static const String channelName = 'Daily Quotes';
  static const String channelDescription =
      'Daily motivational quote notifications';

  Future<void> initialize() async {
    // --------------------------------------------------
    // 1. Initialize local notifications
    // --------------------------------------------------

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        print('Notification clicked: ${response.payload}');
      },
    );

    // --------------------------------------------------
    // 2. Create Android notification channel
    // --------------------------------------------------

    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // --------------------------------------------------
    // 3. Request notification permission
    // --------------------------------------------------

    final permission =
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(
      'Notification permission: '
          '${permission.authorizationStatus}',
    );

    // --------------------------------------------------
    // 4. Subscribe to daily quote topic
    // --------------------------------------------------

    await _firebaseMessaging.subscribeToTopic(
      'daily_quotes',
    );

    print('Subscribed to daily_quotes');

    // --------------------------------------------------
    // 5. Get FCM token
    // --------------------------------------------------

    final token = await _firebaseMessaging.getToken();

    print('=================================');
    print('FCM TOKEN');
    print(token);
    print('=================================');

    // --------------------------------------------------
    // 6. Foreground notification
    // --------------------------------------------------

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        print('Foreground notification received');

        print(
          'Title: ${message.notification?.title}',
        );

        print(
          'Body: ${message.notification?.body}',
        );

        _showLocalNotification(message);
      },
    );

    // --------------------------------------------------
    // 7. Notification opened
    // --------------------------------------------------

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        print('Notification clicked');

        print('Data: ${message.data}');
      },
    );

    // --------------------------------------------------
    // 8. App opened from terminated state
    // --------------------------------------------------

    final initialMessage =
    await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      print('App opened from notification');

      print(
        'Data: ${initialMessage.data}',
      );
    }
  }

  Future<void> _showLocalNotification(
      RemoteMessage message,
      ) async {
    final notification = message.notification;

    if (notification == null) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification.title,
      body: notification.body,
      notificationDetails: notificationDetails,
      payload: message.data.toString(),
    );
  }
}