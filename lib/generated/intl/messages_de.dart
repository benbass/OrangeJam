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
      "Wählen Sie die ZIP Datei mit der gewünschten Sicherung im \'${appName} Playlists\' Ordner in Ihrem Google Drive aus.";

  static String m1(fileName) => "Die Tags von ${fileName} wurden aktualisiert.";

  static String m2(trackName) =>
      "Der Titel \'${trackName}\' wurde der Queue hinzugefügt.";

  static String m3(filePath) =>
      "Ups, die Datei \'${filePath}\' wurde nicht gefunden oder Berechtigungen fehlen!";

  static String m4(name) => "Die Playlist \'${name}\' wurde gelöscht.";

  static String m5(name) => "Die Playlist \'${name}\' wird endgültig gelöscht.";

  static String m6(name) =>
      "Die Playlist \'${name}\' existiert bereits.\nBitte einen anderen Namen vergeben.";

  static String m7(name) => "Die Playlist \'${name}\' wurde erstellt.";

  static String m8(selectedVal) =>
      "Dieser Titel befindet sich bereits in der Playlist \'${selectedVal}\'.";

  static String m9(selectedVal) =>
      "Der Titel wurde zur Playlist \'${selectedVal}\' hinzugefügt.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "album": MessageLookupByLibrary.simpleMessage("Album: "),
        "albumArtist": MessageLookupByLibrary.simpleMessage("Album Künstler: "),
        "artist": MessageLookupByLibrary.simpleMessage("Künstler: "),
        "backupRestore_backupAborted":
            MessageLookupByLibrary.simpleMessage("Sicherung abgebrochen."),
        "backupRestore_backupFileNotCreated":
            MessageLookupByLibrary.simpleMessage(
                "Die Sicherung konnte nicht erstellt werden."),
        "backupRestore_error": MessageLookupByLibrary.simpleMessage("Fehler"),
        "backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain":
            MessageLookupByLibrary.simpleMessage(
                "Fehler beim Holen der Sicherungsdatei.\nBitte versuchen Sie es nochmal."),
        "backupRestore_hasBeenSaved": MessageLookupByLibrary.simpleMessage(
            " mit Ihrer Sicherung wurde gespeichert."),
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
                "Sie sind nicht in Ihrem Google Konto angemeldet"),
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
        "cutomWidgets_aZipArchiveWillBeCreatedAndSaved":
            MessageLookupByLibrary.simpleMessage(
                "Es wird ein ZIP-Archiv erstellt und an einem Ort Ihrer Wahl gespeichert"),
        "cutomWidgets_aZipArchiveWillBeCreatedAndUploaded":
            MessageLookupByLibrary.simpleMessage(
                "Eine ZIP Datei wird erstellt und auf Ihren Google Drive hochgeladen"),
        "cutomWidgets_pickTheZipFileThatContainsYourBackup": m0,
        "drawer_automaticPlayback":
            MessageLookupByLibrary.simpleMessage("Automatische Wiedergabe"),
        "drawer_backup": MessageLookupByLibrary.simpleMessage("Sicherung"),
        "drawer_language": MessageLookupByLibrary.simpleMessage("Sprache"),
        "drawer_playlists": MessageLookupByLibrary.simpleMessage("Playliste"),
        "drawer_restore":
            MessageLookupByLibrary.simpleMessage("Wiederherstellung"),
        "drawer_scanDevice":
            MessageLookupByLibrary.simpleMessage("Datenbank aktualisieren"),
        "duration": MessageLookupByLibrary.simpleMessage("Dauer: "),
        "edit_tags_editTags":
            MessageLookupByLibrary.simpleMessage("Tags bearbeiten"),
        "edit_tags_selectPicture":
            MessageLookupByLibrary.simpleMessage("Bild\nauswählen"),
        "edit_tags_snackBarUpdateError": MessageLookupByLibrary.simpleMessage(
            "Beim Schreiben in die Datei ist ein Fehler aufgetreten.\nÜberprüfen Sie die Datei und versuchen Sie es erneut."),
        "edit_tags_snackBarUpdateSuccess": m1,
        "edit_tags_trackTitle": MessageLookupByLibrary.simpleMessage("Titel"),
        "edit_tags_tracksTotal":
            MessageLookupByLibrary.simpleMessage("Titel gesamt"),
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
        "help": MessageLookupByLibrary.simpleMessage("Hilfe"),
        "help_add_to_playlist": MessageLookupByLibrary.simpleMessage(
            "Zu Playlist\n/ Queue\nhinzufügen"),
        "help_add_to_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Den Titel nach rechts wischen und die gewünschte Option wählen."),
        "help_automatic_playback":
            MessageLookupByLibrary.simpleMessage("Automatische\nWiedergabe"),
        "help_automatic_playback_desc": MessageLookupByLibrary.simpleMessage(
            "Aktivieren Sie diesen Modus im Einstellungsmenü.\nBitte beachten Sie, dass eine Liste nicht automatisch gestartet wird, wenn Sie die App starten.\nDer Modus funktioniert nur, wenn Sie zu einer anderen Liste wechseln."),
        "help_backup_restore": MessageLookupByLibrary.simpleMessage(
            "Backup &\nWiederherst.\nder Playlisten"),
        "help_backup_restore_desc": MessageLookupByLibrary.simpleMessage(
            "Bei der Sicherung wird eine Archivdatei (zip) auf Ihr Google Drive hochgeladen. Sie müssen bei Ihrem Google-Konto angemeldet sein.\n\nBei der Wiederherstellung werden Sie aufgefordert, eine zuvor erstellte Archivdatei aus Ihrem Google Drive auszuwählen.\nWiederhergestellte Playlisten werden zu bestehenden Playlisten hinzugefügt. Wenn Playlisten mit demselben Namen bereits in der App vorhanden sind, werden sie überschrieben."),
        "help_create_playlist":
            MessageLookupByLibrary.simpleMessage("Playlist\nerstellen"),
        "help_create_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Unten in der App auf die Schaltfläche \'OrangeJam\' und dann auf die Schaltfläche \'+\' tippen."),
        "help_delete_playlist":
            MessageLookupByLibrary.simpleMessage("Playlist\nlöschen"),
        "help_delete_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Unten in der App auf die Schaltfläche \'OrangeJam\' tippen und dann lange auf die zu löschende Playlist drücken."),
        "help_edit_tags":
            MessageLookupByLibrary.simpleMessage("Tags bearbeiten"),
        "help_edit_tags_desc": MessageLookupByLibrary.simpleMessage(
            "Den Titel nach links wischen oder auf die Schaltfläche \'Bearbeiten\' in der Playersteuerung tippen.\nDie letztgenannte Option ist nur für den gerade abgespielten Titel verfügbar."),
        "help_or": MessageLookupByLibrary.simpleMessage(" oder "),
        "help_play": MessageLookupByLibrary.simpleMessage("Abspielen"),
        "help_play_desc":
            MessageLookupByLibrary.simpleMessage("Auf Titel tippen."),
        "help_refresh":
            MessageLookupByLibrary.simpleMessage("Datenbank\naktualisieren"),
        "help_refresh_desc": MessageLookupByLibrary.simpleMessage(
            "Nachdem Sie Dateien aus Ihrer Musikbibliothek gelöscht oder hinzugefügt haben (mit einer Dateimanager-App), sollten Sie die Datenbank aktualisieren, damit sie den aktuellen Stand Ihrer Bibliothek wiedergibt."),
        "help_remove_from_playlist": MessageLookupByLibrary.simpleMessage(
            "Von Playlist\n/ Queue\nentfernen"),
        "help_remove_from_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Den Titel nach links wischen und entfernen.\nDadurch wird der Titel sofort entfernt und, im Falle einer Playlist, der neue Status dieser Playlist gespeichert.\nBeachten Sie, dass diese Option nicht für \'Dateien\' verfügbar ist, da die App nur Elemente aus Playlisten entfernen kann: Sie kann keine Dateien löschen.\nWenn Sie eine Datei von Ihrem Gerät entfernen möchten, verwenden Sie bitte die Dateimanager-App Ihrer Wahl. Wenn Sie fertig sind, gehen Sie zu den Einstellungen der App und scannen Sie Ihr Gerät, um die Datenbank zu aktualisieren."),
        "help_reorder_tracks":
            MessageLookupByLibrary.simpleMessage("Titel\nneu ordnen"),
        "help_reorder_tracks_desc": MessageLookupByLibrary.simpleMessage(
            "Lange auf den Titel drücken und diesen in die neue Position schieben.\nBeachten Sie, dass die neue Reihenfolge bei Playlists sofort gespeichert wird. Bei \'Dateien\' und \'Queue\' geht die Reihenfolge verloren, wenn Sie eine andere Liste öffnen."),
        "help_repeat_track":
            MessageLookupByLibrary.simpleMessage("Titel\nwiederholen"),
        "help_repeat_track_desc": MessageLookupByLibrary.simpleMessage(
            "Auf die Schaltfläche \'Titel wiederholen\' in der Playersteuerung tippen."),
        "help_shuffle": MessageLookupByLibrary.simpleMessage("Mischen"),
        "help_shuffle_desc": MessageLookupByLibrary.simpleMessage(
            "Auf die Schaltfläche \'Mischen\' in der Playersteuerung tippen."),
        "help_stop": MessageLookupByLibrary.simpleMessage("Stop"),
        "help_stop_desc": MessageLookupByLibrary.simpleMessage(
            "Erneut auf den Titel tippen ODER auf die Stopptaste in der Playersteuerung tippen."),
        "help_view_tags": MessageLookupByLibrary.simpleMessage("Tags ansehen"),
        "help_view_tags_desc": MessageLookupByLibrary.simpleMessage(
            "Auf die Schaltfläche \'Info\' in der Playersteuerung tippen.\nDiese Funktion ist nur verfügbar, wenn ein Titel abgespielt wird."),
        "homePage_LoadingTracks":
            MessageLookupByLibrary.simpleMessage("Lade Titel ..."),
        "homePage_ScanningDevice":
            MessageLookupByLibrary.simpleMessage("Durchsuche Gerät ..."),
        "initializeAwesomeNotification_allowNotifications":
            MessageLookupByLibrary.simpleMessage("Benachrichtigungen erlauben"),
        "initializeAwesomeNotification_ourAppWouldLikeToSendYouNotifications":
            MessageLookupByLibrary.simpleMessage(
                "Die App möchte Benachrichtungen anzeigen"),
        "listItemSlidable_remove":
            MessageLookupByLibrary.simpleMessage("Entfernen"),
        "listItemSlidable_theQueueAlreadyContainsThisTrack":
            MessageLookupByLibrary.simpleMessage(
                "Dieser Titel befindet sich bereits in der Queue."),
        "listItemSlidable_theTrackTracktracknameIsNowAddedToTheQueue": m2,
        "listItemSlidable_upsTheFileTrackfilepathWasNotFound": m3,
        "loopButton_LoopPlaybackIsOff":
            MessageLookupByLibrary.simpleMessage("Titel Wiederholung ist aus"),
        "loopButton_LoopPlaybackIsOn":
            MessageLookupByLibrary.simpleMessage("Titel Wiederholung ist an"),
        "playlistButton_SnackbarNameWasDeleted": m4,
        "playlistButton_ThisWillDefinitelyDeleteThePlaylist": m5,
        "playlistHandler_addThisTrackToPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Titel zur Playlist hinzufügen: "),
        "playlistHandler_enterANameForYourNewPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Name für die neue Playlist vergeben!"),
        "playlistHandler_pick":
            MessageLookupByLibrary.simpleMessage("Auswählen"),
        "playlistHandler_pickAPlaylist":
            MessageLookupByLibrary.simpleMessage("Playlist auswählen!"),
        "playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName":
            m6,
        "playlistHandler_thePlaylistNameWasCreated": m7,
        "playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack": m8,
        "playlistHandler_theTrackWasAddedToThePlaylistSelectedval": m9,
        "playlistHandler_youDontHaveAnyPlaylistYet":
            MessageLookupByLibrary.simpleMessage(
                "Sie haben noch keine Playlist!"),
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
            MessageLookupByLibrary.simpleMessage("Titel Name"),
        "storage_permissions_dialog_content": MessageLookupByLibrary.simpleMessage(
            "Erteilen Sie die Berechtigung für Speicher in den App-Einstellungen"),
        "storage_permissions_dialog_content_33":
            MessageLookupByLibrary.simpleMessage(
                "Erteilen Sie die Berechtigung für Musik und Audio in den App-Einstellungen"),
        "storage_permissions_dialog_description":
            MessageLookupByLibrary.simpleMessage(
                "Zugang zu Audiodateien ist erforderlich"),
        "track": MessageLookupByLibrary.simpleMessage("Titel: "),
        "trackNo": MessageLookupByLibrary.simpleMessage("Titel Nr: "),
        "year": MessageLookupByLibrary.simpleMessage("Jahr: ")
      };
}
