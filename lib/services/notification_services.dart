import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationService {
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'High Importance Notifications',
          channelDescription: 'Channel for important notifications',
          defaultColor: AppColors.to.primaryBgColor,
          ledColor: AppColors.to.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel',
          channelGroupName: "Group 1",
        ),
      ],
      debug: true,
    );

    // Request notification permission if not allowed
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // Set listeners for notification events
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );

    // Listen to Firebase Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("🔥 Foreground Message Received!");

      String? title = message.notification?.title ?? message.data['title'];
      String? body = message.notification?.body ?? message.data['body'];

      log("📌 Title: $title");
      log("📌 Body: $body");

      showNotification(title: title ?? "No Title", body: body ?? "No Body");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("🚀 App Opened by Notification: ${message.data}");
      Get.toNamed(AppRoutes.mainScreen);
    });
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    log("📩 Notification Action Received: ${receivedAction.payload}");
    final payload = receivedAction.payload ?? {};

    if (payload["navigate"] == "true") {
      if (Get.context == null) {
        await Get.toNamed(AppRoutes.homeScreen);
      } else {
        Get.toNamed(AppRoutes.homeScreen);
      }

      Fluttertoast.showToast(
        msg: "Action button notification clicked",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.to.white,
        textColor: AppColors.to.primaryBgColor,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> onNotificationCreatedMethod(ReceivedNotification notification) async {
    log("✅ Notification Created: ${notification.id}");
  }

  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedAction) async {
    log("📢 Notification Displayed: ${receivedAction.id}");
  }

  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    log("❌ Notification Dismissed: ${receivedAction.id}");
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final Duration? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
        interval: interval,
        timeZone: AwesomeNotifications.localTimeZoneIdentifier,
        preciseAlarm: true,
      )
          : null,
    );
  }
}
