// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(appName) =>
      "Wähle die ZIP Datei mit der gewünschten Sicherung im \'${appName} Playlists\' Ordner in deinem Google Drive aus.";

  static String m1(trackName) =>
      "Der Track \'${trackName}\' wurde der Queue hinzugefügt.";

  static String m2(filePath) =>
      "Ups, die Datei \'${filePath}\' wurde nicht gefunden!";

  static String m3(name) => "Die Playlist \'${name}\' wurde gelöscht.";

  static String m4(name) => "Die Playlist \'${name}\' wird endgültig gelöscht.";

  static String m5(name) =>
      "Die Playlist \'${name}\' existiert bereits.\nBitte einen anderen Namen vergeben.";

  static String m6(name) => "Die Playlist \'${name}\' wurde erstellt.";

  static String m7(selectedVal) =>
      "Dieser Track befindet sich bereits in der Playlist \'${selectedVal}\'.";

  static String m8(selectedVal) =>
      "Der Track wurde zur Playlist \'${selectedVal}\' hinzugefügt.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "album": MessageLookupByLibrary.simpleMessage("Album: "),
        "albumArtist": MessageLookupByLibrary.simpleMessage("Album Künstler: "),
        "artist": MessageLookupByLibrary.simpleMessage("Künstler: "),
        "backupRestore_backupFileNotCreated":
            MessageLookupByLibrary.simpleMessage(
                "Die Sicherung konnte nicht erstellt werden."),
        "backupRestore_error": MessageLookupByLibrary.simpleMessage("Fehler"),
        "backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain":
            MessageLookupByLibrary.simpleMessage(
                "Fehler beim Holen der Sicherungsdatei.\nBitte versuche es nochmal."),
        "backupRestore_hasBeenUploadedToYourGoogleDrive":
            MessageLookupByLibrary.simpleMessage(
                " wurde auf Google Drive hochgeladen."),
        "backupRestore_noBackupFileSelected":
            MessageLookupByLibrary.simpleMessage("Keine Sicherung gewählt."),
        "backupRestore_pleaseTryAgain":
            MessageLookupByLibrary.simpleMessage("Bitte nochmal versuchen."),
        "backupRestore_restoreAborted": MessageLookupByLibrary.simpleMessage(
            "Wiederherstellung abgebrochen."),
        "backupRestore_theFile":
            MessageLookupByLibrary.simpleMessage("Die Datei "),
        "backupRestore_theZipFileDoesNotContainValidPlaylistFilesExtension":
            MessageLookupByLibrary.simpleMessage(
                "Die ZIP Datei enthält keine gültige Playlist Datei (Dateierweiterung: m3u)!"),
        "backupRestore_unableToUpload":
            MessageLookupByLibrary.simpleMessage("Hochladen nicht möglich: "),
        "backupRestore_wasSuccessfullyCreatedIn":
            MessageLookupByLibrary.simpleMessage(
                " wurde erfolgreich erstellt in "),
        "backupRestore_youAreNotSignedInToYourGoogleAccount":
            MessageLookupByLibrary.simpleMessage(
                "Du bist nicht in deinem Google Konto eingeloggt"),
        "backupRestore_yourPlaylistsFromTheBackupFileHaveBeenRestored":
            MessageLookupByLibrary.simpleMessage(
                "Die Playlists aus der Sicherung wurden wiederhergestellt."),
        "buttonBackup": MessageLookupByLibrary.simpleMessage("Sicherung"),
        "buttonCancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "buttonContinue": MessageLookupByLibrary.simpleMessage("Fortsetzen"),
        "buttonOk": MessageLookupByLibrary.simpleMessage("Ok"),
        "buttonRestore":
            MessageLookupByLibrary.simpleMessage("Wiederherstellen"),
        "close": MessageLookupByLibrary.simpleMessage("Schliessen"),
        "continuousPlaybackButton_ContinuousPlaybackIsOff":
            MessageLookupByLibrary.simpleMessage(
                "Kontinuierliches Playback ist aus"),
        "continuousPlaybackButton_ContinuousPlaybackIsOn":
            MessageLookupByLibrary.simpleMessage(
                "Kontinuierliches Playback ist an"),
        "cutomWidgets_aZipArchiveWillBeCreatedAndUploaded":
            MessageLookupByLibrary.simpleMessage(
                "Eine ZIP Datei wird erstellt und auf deinen Google Drive hochgeladen"),
        "cutomWidgets_pickTheZipFileThatContainsYourBackup": m0,
        "drawer_backup": MessageLookupByLibrary.simpleMessage("Sicherung"),
        "drawer_language": MessageLookupByLibrary.simpleMessage("Sprache"),
        "drawer_restore":
            MessageLookupByLibrary.simpleMessage("Wiederherstellung"),
        "drawer_scanDevice":
            MessageLookupByLibrary.simpleMessage("Gerät durchsuchen"),
        "duration": MessageLookupByLibrary.simpleMessage("Dauer: "),
        "extraBar_clear": MessageLookupByLibrary.simpleMessage("Leeren"),
        "extraBar_saveTheQueueAsAPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Die Queue als Playlist speichern: "),
        "extraBar_theQueueIsEmpty":
            MessageLookupByLibrary.simpleMessage("Die Queue ist leer!"),
        "file": MessageLookupByLibrary.simpleMessage("Datei: "),
        "files": MessageLookupByLibrary.simpleMessage("Dateien"),
        "filterByPopUpMenuButton_album":
            MessageLookupByLibrary.simpleMessage("Album"),
        "filterByPopUpMenuButton_filter":
            MessageLookupByLibrary.simpleMessage("Filtern"),
        "filterByPopUpMenuButton_year":
            MessageLookupByLibrary.simpleMessage("Jahr"),
        "genre": MessageLookupByLibrary.simpleMessage("Genre: "),
        "homePage_LoadingTracks":
            MessageLookupByLibrary.simpleMessage("Lade Tracks ..."),
        "homePage_ScanningDevice":
            MessageLookupByLibrary.simpleMessage("Durchsuche Gerät ..."),
        "initializeAwesomeNotification_allow":
            MessageLookupByLibrary.simpleMessage("Erlauben"),
        "initializeAwesomeNotification_allowNotifications":
            MessageLookupByLibrary.simpleMessage("Benachrichtigungen erlauben"),
        "initializeAwesomeNotification_dontAllow":
            MessageLookupByLibrary.simpleMessage("nicht erlauben"),
        "initializeAwesomeNotification_ourAppWouldLikeToSendYouNotifications":
            MessageLookupByLibrary.simpleMessage(
                "Die App möchte Benachrichtungen anzeigen"),
        "listItemSlidable_remove":
            MessageLookupByLibrary.simpleMessage("Entfernen"),
        "listItemSlidable_theQueueAlreadyContainsThisTrack":
            MessageLookupByLibrary.simpleMessage(
                "Dieser Track befindet sich bereits in der Queue."),
        "listItemSlidable_theTrackTracktracknameIsNowAddedToTheQueue": m1,
        "listItemSlidable_upsTheFileTrackfilepathWasNotFound": m2,
        "loopButton_LoopPlaybackIsOff":
            MessageLookupByLibrary.simpleMessage("Track Wiederholung ist an"),
        "loopButton_LoopPlaybackIsOn":
            MessageLookupByLibrary.simpleMessage("Track Wiederholung ist aus"),
        "playlistButton_SnackbarNameWasDeleted": m3,
        "playlistButton_ThisWillDefinitelyDeleteThePlaylist": m4,
        "playlistHandler_addThisTrackToPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Track zur Playlist hinzufügen: "),
        "playlistHandler_enterANameForYourNewPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Name für die neue Playlist vergeben!"),
        "playlistHandler_pick":
            MessageLookupByLibrary.simpleMessage("Auswählen"),
        "playlistHandler_pickAPlaylist":
            MessageLookupByLibrary.simpleMessage("Playlist auswählen!"),
        "playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName":
            m5,
        "playlistHandler_thePlaylistNameWasCreated": m6,
        "playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack": m7,
        "playlistHandler_theTrackWasAddedToThePlaylistSelectedval": m8,
        "playlistHandler_youDontHaveAnyPlaylistYet":
            MessageLookupByLibrary.simpleMessage(
                "Du hast noch keine Playlist!"),
        "playlistsMenu_NewPlaylist":
            MessageLookupByLibrary.simpleMessage("Neue Playlist: "),
        "queue": MessageLookupByLibrary.simpleMessage("Queue"),
        "save": MessageLookupByLibrary.simpleMessage("Speichern"),
        "sortByDropdown_artist":
            MessageLookupByLibrary.simpleMessage("Künstler"),
        "sortByDropdown_creationDate":
            MessageLookupByLibrary.simpleMessage("Erstelldatun"),
        "sortByDropdown_fileName":
            MessageLookupByLibrary.simpleMessage("Datei Name"),
        "sortByDropdown_genre": MessageLookupByLibrary.simpleMessage("Genre"),
        "sortByDropdown_reset":
            MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
        "sortByDropdown_shuffle":
            MessageLookupByLibrary.simpleMessage("Mischen"),
        "sortByDropdown_sort":
            MessageLookupByLibrary.simpleMessage("Sortieren"),
        "sortByDropdown_trackName":
            MessageLookupByLibrary.simpleMessage("Track Name"),
        "track": MessageLookupByLibrary.simpleMessage("Track: "),
        "trackNo": MessageLookupByLibrary.simpleMessage("Track Nr: "),
        "year": MessageLookupByLibrary.simpleMessage("Jahr: ")
      };
}
