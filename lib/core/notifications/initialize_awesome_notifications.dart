import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:orangejam/services/notification_controller.dart';

import '../../generated/l10n.dart';
import '../../presentation/homepage/custom_widgets/custom_widgets.dart';
import '../globals.dart';

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

  void closeDialog(){
    Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
  }

  // Check if user granted permmission for notification
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    // if not, dialog informs user app wants to sent notifications
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
              // AwesomeNotifications shows new dialog for permission
              themeData: themeData,
              function: () => AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then((_) => closeDialog()),
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
