// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(appName) =>
      "Pick the ZIP file that contains your backup in the \'${appName} Playlists\' folder in your Google Drive.";

  static String m1(fileName) =>
      "The tags of ${fileName} have been successfully updated.";

  static String m2(trackName) =>
      "The track \'${trackName}\' is now added to the queue.";

  static String m3(filePath) => "Ups, the file \'${filePath}\' was not found!";

  static String m4(name) => "The playlist \'${name}\' was deleted.";

  static String m5(name) => "This will definitely delete the playlist: ${name}";

  static String m6(name) =>
      "The playlist \'${name}\' already exists.\nPlease choose another name.";

  static String m7(name) => "The playlist \'${name}\' was created.";

  static String m8(selectedVal) =>
      "The playlist \'${selectedVal}\' already contains this track.";

  static String m9(selectedVal) =>
      "The track was added to the playlist \'${selectedVal}\'.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "album": MessageLookupByLibrary.simpleMessage("Album: "),
        "albumArtist": MessageLookupByLibrary.simpleMessage("Album artist: "),
        "artist": MessageLookupByLibrary.simpleMessage("Artist: "),
        "backupRestore_backupFileNotCreated":
            MessageLookupByLibrary.simpleMessage("Backup file not created."),
        "backupRestore_error": MessageLookupByLibrary.simpleMessage("Error"),
        "backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain":
            MessageLookupByLibrary.simpleMessage(
                "Error while retrieving the backup file.\nPlease try again."),
        "backupRestore_hasBeenUploadedToYourGoogleDrive":
            MessageLookupByLibrary.simpleMessage(
                " has been uploaded to your Google Drive."),
        "backupRestore_noBackupFileSelected":
            MessageLookupByLibrary.simpleMessage("No backup file selected."),
        "backupRestore_pleaseTryAgain":
            MessageLookupByLibrary.simpleMessage("Please try again."),
        "backupRestore_restoreAborted":
            MessageLookupByLibrary.simpleMessage("Restore aborted."),
        "backupRestore_theFile":
            MessageLookupByLibrary.simpleMessage("The file "),
        "backupRestore_theZipFileDoesNotContainValidPlaylistFilesExtension":
            MessageLookupByLibrary.simpleMessage(
                "The Zip file does not contain valid playlist files (extension: m3u) for this app!"),
        "backupRestore_unableToUpload":
            MessageLookupByLibrary.simpleMessage("Unable to upload: "),
        "backupRestore_wasSuccessfullyCreatedIn":
            MessageLookupByLibrary.simpleMessage(
                " was successfully created in "),
        "backupRestore_youAreNotSignedInToYourGoogleAccount":
            MessageLookupByLibrary.simpleMessage(
                "You are not signed in to your Google account"),
        "backupRestore_yourPlaylistsFromTheBackupFileHaveBeenRestored":
            MessageLookupByLibrary.simpleMessage(
                "Your playlists from the backup file have been restored."),
        "buttonBackup": MessageLookupByLibrary.simpleMessage("Backup"),
        "buttonCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "buttonContinue": MessageLookupByLibrary.simpleMessage("Continue"),
        "buttonOk": MessageLookupByLibrary.simpleMessage("Ok"),
        "buttonRestore": MessageLookupByLibrary.simpleMessage("Restore"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "cutomWidgets_aZipArchiveWillBeCreatedAndUploaded":
            MessageLookupByLibrary.simpleMessage(
                "A ZIP archive will be created and uploaded to your Google Drive"),
        "cutomWidgets_pickTheZipFileThatContainsYourBackup": m0,
        "drawer_automaticPlayback":
            MessageLookupByLibrary.simpleMessage("Automatic playback"),
        "drawer_backup": MessageLookupByLibrary.simpleMessage("Backup"),
        "drawer_language": MessageLookupByLibrary.simpleMessage("Language"),
        "drawer_playlists": MessageLookupByLibrary.simpleMessage("Playlists"),
        "drawer_restore": MessageLookupByLibrary.simpleMessage("Restore"),
        "drawer_scanDevice":
            MessageLookupByLibrary.simpleMessage("Refresh database"),
        "duration": MessageLookupByLibrary.simpleMessage("Duration: "),
        "edit_tags_editTags": MessageLookupByLibrary.simpleMessage("Edit tags"),
        "edit_tags_selectPicture":
            MessageLookupByLibrary.simpleMessage("Select\npicture"),
        "edit_tags_snackBarUpdateError": MessageLookupByLibrary.simpleMessage(
            "An error occurred when writing to the file.\nCheck the file and try again."),
        "edit_tags_snackBarUpdateSuccess": m1,
        "edit_tags_trackTitle": MessageLookupByLibrary.simpleMessage("Title"),
        "edit_tags_tracksTotal":
            MessageLookupByLibrary.simpleMessage("Tracks total"),
        "extraBar_clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "extraBar_saveTheQueueAsAPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Save the queue as a playlist:"),
        "extraBar_theQueueIsEmpty":
            MessageLookupByLibrary.simpleMessage("The queue is empty!"),
        "file": MessageLookupByLibrary.simpleMessage("File: "),
        "files": MessageLookupByLibrary.simpleMessage("Files"),
        "filterByPopUpMenuButton_album":
            MessageLookupByLibrary.simpleMessage("Album"),
        "filterByPopUpMenuButton_filter":
            MessageLookupByLibrary.simpleMessage("Filter"),
        "filterByPopUpMenuButton_year":
            MessageLookupByLibrary.simpleMessage("Year"),
        "genre": MessageLookupByLibrary.simpleMessage("Genre: "),
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "help_add_to_playlist":
            MessageLookupByLibrary.simpleMessage("Add to\nplaylist / queue"),
        "help_add_to_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Swipe track to the right and select the desired option."),
        "help_automatic_playback":
            MessageLookupByLibrary.simpleMessage("Automatic\nplayback"),
        "help_automatic_playback_desc": MessageLookupByLibrary.simpleMessage(
            "Activate this mode in the settings menu.\nPlease note that a list is not started automatically when you start the app.\nThe mode only works when you switch to another list."),
        "help_backup_restore": MessageLookupByLibrary.simpleMessage(
            "Backup &\nRestore\nplaylists"),
        "help_backup_restore_desc": MessageLookupByLibrary.simpleMessage(
            "During the backup, an archive file (zip) is uploaded to your Google Drive. You must be logged in to your Google account.\n\nWhen restoring, you will be prompted to select a previously created archive file from your Google Drive.\nRestored playlists are added to existing playlists. If playlists with the same name already exist in the app, they will be overwritten."),
        "help_create_playlist":
            MessageLookupByLibrary.simpleMessage("Create a\nplaylist"),
        "help_create_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Tap on the \'OrangeJam\' button at the bottom of the app, then on the \'+\' button."),
        "help_delete_playlist":
            MessageLookupByLibrary.simpleMessage("Delete a\nplaylist"),
        "help_delete_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Tap on the \'OrangeJam\' button at the bottom of the app and then long press on the playlist you want to delete."),
        "help_edit_tags": MessageLookupByLibrary.simpleMessage("Edit tags"),
        "help_edit_tags_desc": MessageLookupByLibrary.simpleMessage(
            "Swipe track to the left or tap on \'Edit\' button in player controls.\nThe latter option is only available for the track currently being played."),
        "help_or": MessageLookupByLibrary.simpleMessage(" or "),
        "help_play": MessageLookupByLibrary.simpleMessage("Play"),
        "help_play_desc": MessageLookupByLibrary.simpleMessage("Tap on track."),
        "help_refresh":
            MessageLookupByLibrary.simpleMessage("Refresh\ndatabase"),
        "help_refresh_desc": MessageLookupByLibrary.simpleMessage(
            "After you have deleted or added audio files from your music library (using a file manager app), you should update the database so that it reflects the current status of your library."),
        "help_remove_from_playlist": MessageLookupByLibrary.simpleMessage(
            "Remove from\nplaylist / queue"),
        "help_remove_from_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Swipe track to the left and remove.\nThis immediately removes the title and, in the case of a playlist, saves the new status of this playlist.\nNote that this option is not available for \'Files\' as the app can only remove items from playlists: It cannot delete files.\nIf you want to remove a file from your device, please use the file manager app of your choice. When done, go to the app settings and scan your device in order to update the database."),
        "help_reorder_tracks":
            MessageLookupByLibrary.simpleMessage("Reorder tracks"),
        "help_reorder_tracks_desc": MessageLookupByLibrary.simpleMessage(
            "Long press on track and slide into new position.\nNote that the new order will be immediately saved for playlists. For \'Files\' and \'Queue\' the order will be lost when you open another list."),
        "help_repeat_track":
            MessageLookupByLibrary.simpleMessage("Repeat track"),
        "help_repeat_track_desc": MessageLookupByLibrary.simpleMessage(
            "Tap on \'Repeat one\' button in player controls."),
        "help_shuffle": MessageLookupByLibrary.simpleMessage("Shuffle"),
        "help_shuffle_desc": MessageLookupByLibrary.simpleMessage(
            "Tap on \'Shuffle\' button in player controls."),
        "help_stop": MessageLookupByLibrary.simpleMessage("Stop"),
        "help_stop_desc": MessageLookupByLibrary.simpleMessage(
            "Tap again on track OR tap on \'Stop\' button in player controls."),
        "help_view_tags": MessageLookupByLibrary.simpleMessage("View tags"),
        "help_view_tags_desc": MessageLookupByLibrary.simpleMessage(
            "Tap on \'Info\' button in player controls.\nThis is only available when a track is being played."),
        "homePage_LoadingTracks":
            MessageLookupByLibrary.simpleMessage("Loading tracks ..."),
        "homePage_ScanningDevice":
            MessageLookupByLibrary.simpleMessage("Scanning device ..."),
        "initializeAwesomeNotification_allowNotifications":
            MessageLookupByLibrary.simpleMessage("Allow Notifications"),
        "initializeAwesomeNotification_ourAppWouldLikeToSendYouNotifications":
            MessageLookupByLibrary.simpleMessage(
                "Our app would like to send you notifications"),
        "listItemSlidable_remove":
            MessageLookupByLibrary.simpleMessage("Remove"),
        "listItemSlidable_theQueueAlreadyContainsThisTrack":
            MessageLookupByLibrary.simpleMessage(
                "The queue already contains this track."),
        "listItemSlidable_theTrackTracktracknameIsNowAddedToTheQueue": m2,
        "listItemSlidable_upsTheFileTrackfilepathWasNotFound": m3,
        "loopButton_LoopPlaybackIsOff":
            MessageLookupByLibrary.simpleMessage("Loop playback is off"),
        "loopButton_LoopPlaybackIsOn":
            MessageLookupByLibrary.simpleMessage("Loop playback is on"),
        "playlistButton_SnackbarNameWasDeleted": m4,
        "playlistButton_ThisWillDefinitelyDeleteThePlaylist": m5,
        "playlistHandler_addThisTrackToPlaylist":
            MessageLookupByLibrary.simpleMessage("Add this track to playlist:"),
        "playlistHandler_enterANameForYourNewPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Enter a name for your new playlist!"),
        "playlistHandler_pick": MessageLookupByLibrary.simpleMessage("Pick"),
        "playlistHandler_pickAPlaylist":
            MessageLookupByLibrary.simpleMessage("Pick a playlist!"),
        "playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName":
            m6,
        "playlistHandler_thePlaylistNameWasCreated": m7,
        "playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack": m8,
        "playlistHandler_theTrackWasAddedToThePlaylistSelectedval": m9,
        "playlistHandler_youDontHaveAnyPlaylistYet":
            MessageLookupByLibrary.simpleMessage(
                "You don\'t have any playlist yet!"),
        "playlistsMenu_NewPlaylist":
            MessageLookupByLibrary.simpleMessage("New playlist: "),
        "queue": MessageLookupByLibrary.simpleMessage("Queue"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "sortByDropdown_artist": MessageLookupByLibrary.simpleMessage("Artist"),
        "sortByDropdown_creationDate":
            MessageLookupByLibrary.simpleMessage("Creation date"),
        "sortByDropdown_fileName":
            MessageLookupByLibrary.simpleMessage("File name"),
        "sortByDropdown_genre": MessageLookupByLibrary.simpleMessage("Genre"),
        "sortByDropdown_reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "sortByDropdown_shuffle":
            MessageLookupByLibrary.simpleMessage("Shuffle"),
        "sortByDropdown_sort": MessageLookupByLibrary.simpleMessage("Sort"),
        "sortByDropdown_trackName":
            MessageLookupByLibrary.simpleMessage("Track name"),
        "storage_permissions_dialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Grant permission for Storage in the app settings"),
        "storage_permissions_dialog_content_33":
            MessageLookupByLibrary.simpleMessage(
                "Grant permission for Music and Audio in the app settings"),
        "storage_permissions_dialog_description":
            MessageLookupByLibrary.simpleMessage(
                "Access to audio files is required"),
        "track": MessageLookupByLibrary.simpleMessage("Track: "),
        "trackNo": MessageLookupByLibrary.simpleMessage("Track no: "),
        "year": MessageLookupByLibrary.simpleMessage("Year: ")
      };
}
