import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;
import 'package:orangejam/injection.dart' as di;

import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../helpers/format_duration.dart';

void createNotification(TrackEntity currentTrack, bool isPausingState, Duration p) async {
  // We create notification only if user tapped on a track.
  // This check is necessary in order to prevent errors when app is resumed or inactive and player is stopped,
  // in which case id == 0, which can causes issues... id 0 is the id of an empty track
  if (currentTrack.id != 0) {
    Duration d = Duration(milliseconds: currentTrack.trackDuration!.toInt());

    final tempDir = await getTemporaryDirectory();
    String filePath = "";

    Uint8List? imageUint8List = currentTrack.albumArt;

    if (imageUint8List != null) {
      // Resize, crop, blur and compress album cover
      int w = 320;
      //final i.Image resizedImage = i.copyResize(i.decodeImage(imageUint8List)!, width: w);
      //final i.Image croppedImage = i.copyCrop(resizedImage, x: 0, y: w~/4, width: w, height: w~/2.25);
      //final i.Image blurredImage = i.gaussianBlur(resizedImage, radius: 0);
      final List<int> compressedBytes = i.encodePng(i.gaussianBlur(i.copyResize(i.decodeImage(imageUint8List)!, width: w), radius: 3));
      final File compressedFile = File('${tempDir.path}/image_compressed.png');
      compressedFile.writeAsBytesSync(compressedBytes);

      filePath = "file://${compressedFile.path}";
    } else {
      filePath = "asset://assets/album-placeholder.png";
    }

    String iconKey = !isPausingState ? 'pause' : 'play';
    NotificationPlayState notificationPlayState = isPausingState
        ? NotificationPlayState.paused
        : NotificationPlayState.playing;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        category: NotificationCategory.Transport,
        title: currentTrack.trackName,
        body: currentTrack.trackArtistNames,
        duration: d,
        progress: unformatedDuration(p).toInt() /
            unformatedDuration(d).toInt() *
            100,
        playbackSpeed: 1,
        largeIcon: filePath,
        bigPicture: filePath,
        icon: "resource://drawable/launcher_icon", // App icon
        backgroundColor: const Color(0x00FFFFFF),//Color(0xFFFF8100),
        autoDismissible: false,
        showWhen: false,
        notificationLayout: NotificationLayout.MediaPlayer,
        locked: true,
        playState: notificationPlayState,
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'STOP',
            icon: 'resource://drawable/res_ic_stop',
            label: 'Idle',
            autoDismissible: false,
            showInCompactView: true,
            enabled: true,
            actionType: ActionType.KeepOnTop),
        NotificationActionButton(
            key: 'SKIPPREV',
            icon: 'resource://drawable/res_ic_prev',
            label: 'Previous',
            autoDismissible: false,
            showInCompactView: true,
            enabled: true,
            actionType: ActionType.KeepOnTop),
        NotificationActionButton(
            key: 'SKIPNEXT',
            icon: 'resource://drawable/res_ic_next',
            label: 'Next',
            autoDismissible: false,
            showInCompactView: true,
            enabled: true,
            actionType: ActionType.KeepOnTop),
        NotificationActionButton(
            key: 'RESUMEPAUSE',
            icon: 'resource://drawable/res_ic_$iconKey',
            label: !di.sl<PlayerControlsBloc>().state.isPausing ? 'Pause' : 'Play',
            autoDismissible: false,
            showInCompactView: true,
            enabled: true,
            actionType: ActionType.KeepOnTop),
      ],
    );
  } else {
    return;
  }
}