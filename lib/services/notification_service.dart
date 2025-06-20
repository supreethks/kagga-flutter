import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kagga/kagga_pager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../db/kagga_db_helper.dart';
import 'package:flutter/material.dart';

// Global navigator key for accessing context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final _prefs = SharedPreferences.getInstance();
  final bool _debugMode = true;
  List<int> _kaggaSequence = [];
  static const int _startDay = 17196; // Starting from Jan 30, 2017

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'daily_kagga',
          actions: [],
          options: {
            DarwinNotificationCategoryOption.allowAnnouncement,
            DarwinNotificationCategoryOption.allowInCarPlay,
          },
        ),
      ],
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    await _loadKaggaSequence();
    tz.initializeTimeZones();
  }

  Future<bool> _requestPermissions() async {
    if (Theme.of(navigatorKey.currentContext!).platform == TargetPlatform.iOS) {
      final ios = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        final result = await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: false,
          critical: true,
        );
        return result ?? false;
      }
      return false;
    } else {
      final androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final areEnabled =
            await androidImplementation.areNotificationsEnabled() ?? false;
        if (!areEnabled) {
          final granted =
              await androidImplementation.requestNotificationsPermission();
          if (granted != true) {
            final context = navigatorKey.currentContext;
            if (context != null) {
              final shouldOpenSettings = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications Disabled'),
                  content: const Text(
                      'Please enable notifications in settings to receive daily kaggas.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              );
              if (shouldOpenSettings == true) {
                if (Platform.isAndroid) {
                  final platform = const MethodChannel('app_settings');
                  try {
                    await platform.invokeMethod('openNotificationSettings');
                  } catch (e) {
                    debugPrint('Error opening settings: $e');
                  }
                }
              }
            }
            return false;
          }
          return granted ?? false;
        }
        return areEnabled;
      }
      return false;
    }
  }

  Future<bool> isEnabled() async {
    final prefs = await _prefs;
    final isEnabled = prefs.getBool('notifications_enabled') ?? false;

    // If notifications are enabled, verify permission is still granted
    if (isEnabled) {
      final androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final permissionStatus =
            await androidImplementation.areNotificationsEnabled();
        if (permissionStatus == false) {
          // Permission was revoked, update the stored state
          await prefs.setBool('notifications_enabled', false);
          return false;
        }
      }
    }
    return isEnabled;
  }

  Future<void> toggleNotifications(bool enable) async {
    final prefs = await _prefs;
    debugPrint('Toggling notifications: $enable');
    if (enable) {
      // Request permissions first
      final permissionGranted = await _requestPermissions();
      debugPrint('Permission granted: $permissionGranted');
      if (!permissionGranted) {
        debugPrint('Permission denied, updating switch state');
        // If permission is denied, update the switch state
        await prefs.setBool('notifications_enabled', false);
        return;
      }

      try {
        debugPrint('Attempting to show instant notification');
        await _showInstantNotification();
        debugPrint('Instant notification completed');

        debugPrint('Attempting to schedule daily notification');
        await _scheduleDailyNotification();
        debugPrint('Daily notification scheduled');

        await prefs.setBool('notifications_enabled', true);
        debugPrint('Notifications enabled successfully');
      } catch (e, stackTrace) {
        debugPrint('Error in toggleNotifications: $e');
        debugPrint('Stack trace: $stackTrace');
        await prefs.setBool('notifications_enabled', false);
        return;
      }
    } else {
      try {
        debugPrint('Canceling all notifications');
        await _notifications.cancelAll();
        await prefs.setBool('notifications_enabled', false);
        debugPrint('Notifications disabled successfully');
      } catch (e) {
        debugPrint('Error canceling notifications: $e');
      }
    }
  }

  void _handleNotificationTap(NotificationResponse details) {
    debugPrint('Notification tapped!');
    try {
      final payload = details.payload;
      debugPrint('Notification payload: $payload');
      if (payload != null) {
        final kaggaId = int.parse(payload);
        debugPrint('Navigating to Kagga ID: $kaggaId');
        final navigator = navigatorKey.currentState;
        if (navigator != null) {
          navigator.push(
            MaterialPageRoute(
              builder: (context) => Theme(
                data: Theme.of(context),
                child: KaggaPager(kaggaIds: [kaggaId], initialIndex: 0),
              ),
            ),
          );
          debugPrint('Navigation pushed successfully');
        } else {
          debugPrint('Navigator is null!');
        }
      }
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }

  Future<String> _getKaggaText(int id) async {
    try {
      final kagga = await getKagga(id);
      return kagga.kaggaKn;
    } catch (e) {
      debugPrint('Error getting kagga text: $e');
      return 'ಕಗ್ಗ ಲಭ್ಯವಿಲ್ಲ';
    }
  }

  Future<void> _loadKaggaSequence() async {
    if (_kaggaSequence.isNotEmpty) return;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/kagga_sequence.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      _kaggaSequence = List<int>.from(data['sequence']);
    } catch (e) {
      debugPrint('Error loading kagga sequence: $e');
      // Fallback to a default sequence if loading fails
      _kaggaSequence = [1, 2, 3, 4, 5];
    }
  }

  Future<int> _getKaggaIdForToday() async {
    await _loadKaggaSequence();
    try {
      // Get days since epoch
      final today = DateTime.now().millisecondsSinceEpoch ~/ 86400000;
      final index = today - _startDay;
      // Use modulo to cycle through the array
      return _kaggaSequence[index % _kaggaSequence.length];
    } catch (e) {
      debugPrint('Error getting kagga ID for today: $e');
      // Return a default ID if calculation fails
      return 1;
    }
  }

  Future<void> _showInstantNotification() async {
    try {
      final kaggaId = await _getKaggaIdForToday();
      debugPrint('Showing instant notification for kagga ID: $kaggaId');

      const androidDetails = AndroidNotificationDetails(
        'daily_kagga',
        'Daily Kagga',
        channelDescription: 'Daily notification for Mankutimma Kagga',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(''),
      );
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: 'daily_kagga',
        interruptionLevel: InterruptionLevel.active,
      );
      debugPrint('Created notification details');

      await _notifications.show(
        0,
        'ದಿನದ ಕಗ್ಗ',
        'Daily notifications enabled. You will receive kaggas every day at 8 AM.',
        const NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        ),
        payload: kaggaId.toString(),
      );
      debugPrint('Notification show() called successfully');
    } catch (e, stackTrace) {
      debugPrint('Error showing instant notification: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> _scheduleDailyNotification() async {
    try {
      debugPrint('Scheduling daily notification, debug mode: $_debugMode');
      if (_debugMode) {
        // Get today's kagga for testing
        final kaggaId = await _getKaggaIdForToday();
        final kaggaText = await _getKaggaText(kaggaId);
        debugPrint(
            'Debug mode: Scheduling notification with kagga ID: $kaggaId');

        final androidDetails = AndroidNotificationDetails(
          'daily_kagga',
          'Daily Kagga',
          channelDescription: 'Daily notification for Mankutimma Kagga',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          styleInformation: BigTextStyleInformation(kaggaText),
        );
        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          categoryIdentifier: 'daily_kagga',
          interruptionLevel: InterruptionLevel.active,
        );

        debugPrint('Debug mode: Setting up periodic notification');
        // In debug mode, schedule periodic notifications every minute
        await _notifications.periodicallyShow(
          1,
          'ದಿನದ ಕಗ್ಗ $kaggaId',
          kaggaText,
          RepeatInterval.everyMinute,
          NotificationDetails(
            android: androidDetails,
            iOS: iosDetails,
          ),
          payload: kaggaId.toString(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
        debugPrint('Debug mode: Periodic notification scheduled successfully');
      } else {
        // In production, schedule daily notifications at 8 AM
        final now = DateTime.now();
        var scheduledDate = DateTime(
          now.year,
          now.month,
          now.day,
          8, // 8 AM
          0,
        );

        // If it's already past 8 AM, schedule for tomorrow
        if (now.isAfter(scheduledDate)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        // Get today's kagga ID and text
        final kaggaId = await _getKaggaIdForToday();
        final kaggaText = await _getKaggaText(kaggaId);

        final androidDetails = AndroidNotificationDetails(
          'daily_kagga',
          'Daily Kagga',
          channelDescription: 'Daily notification for Mankutimma Kagga',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          styleInformation: BigTextStyleInformation(kaggaText),
        );
        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          categoryIdentifier: 'daily_kagga',
        );

        await _notifications.zonedSchedule(
          1,
          'ದಿನ� ಕಗ್ಗ $kaggaId',
          kaggaText,
          tz.TZDateTime.from(scheduledDate, tz.local),
          NotificationDetails(
            android: androidDetails,
            iOS: iosDetails,
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: kaggaId.toString(),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error scheduling daily notification: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> cancelNotifications() async {
    await _notifications.cancelAll();
  }
}
