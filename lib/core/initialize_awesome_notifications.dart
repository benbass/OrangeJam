import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:orange_player/services/notification_controller.dart';

import '../generated/l10n.dart';
import '../presentation/homepage/custom_widgets/custom_widgets.dart';
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
    // debug: true,
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
          content: Text(S.of(context).initializeAwesomeNotification_ourAppWouldLikeToSendYouNotifications),
          actions: [
            SimpleButton(
              themeData: themeData,
              btnText: S.of(context).buttonCancel,
              function: () {
                Navigator.of(context).pop();
              },
            ),
            SimpleButton(
              themeData: themeData,
              function: () => AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then((_) => Navigator.pop(context)),
              btnText: S.of(context).buttonOk,
            ),
          ],
          showDropdown: false,
          titleWidget: DescriptionText(
            themeData: themeData,
            description: S.of(context).initializeAwesomeNotification_allowNotifications,
          ),
          themeData: themeData,
        ),
      );
    }
  });
}
