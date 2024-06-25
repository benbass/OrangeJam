import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:orange_player/services/notification_controller.dart';

import '../presentation/homepage/dialogs/widgets/custom_widgets.dart';
import 'globals.dart';

void initAwesomeNotifications() {
  final themeData = Theme.of(globalScaffoldKey.scaffoldKey.currentContext!);
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: '$appName Player Track Playing',
        channelDescription: 'Notification channel for the $appName Player',
        //defaultColor: const Color(0xFFFF8100),
        //ledColor: Colors.white,
        playSound: false,
        enableVibration: false,
        importance: NotificationImportance.High,
        channelShowBadge: false,
        locked: true,
        defaultPrivacy: NotificationPrivacy.Public,
        icon: "resource://drawable/launcher_icon",
      )
    ],
    debug: true,
  );
  // Only after at least the action method is set, the notification events are delivered
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    /*
    onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
    onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    */
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      showDialog(
        context: globalScaffoldKey.scaffoldKey.currentContext!,
        builder: (context) => CustomDialog(
          content: const Text('Our app would like to send you notifications'),
          actions: [
            SimpleButton(
              themeData: themeData,
              btnText: 'Don\'t Allow',
            ),
            ElevatedButton(
              onPressed: () => AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then((_) => Navigator.pop(context)),
              style: themeData.elevatedButtonTheme.style,
              child: const Text('Allow'),
            ),
          ],
          showDropdown: false,
          titleWidget: DescriptionText(
            themeData: themeData,
            description: 'Allow Notifications',
          ),
          themeData: themeData,
        ),
      );
    }
  });
}
