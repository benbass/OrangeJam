// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(appName) =>
      "Choisis le fichier ZIP qui contient le backup dans le dossier \'${appName} Playlists\' dans ton Google Drive.";

  static String m1(trackName) =>
      "Le titre \'${trackName}\' a été ajouté à la queue.";

  static String m2(filePath) =>
      "Ups, le fichier \'${filePath}\' n\'existe pas!";

  static String m3(name) => "La playlist \'${name}\' a été supprimée.";

  static String m4(name) =>
      "La playlist \'${name}\' va être définitivement supprimée";

  static String m5(name) =>
      "La playlist \'${name}\' existe déjà.\nChoisis un autre nom.";

  static String m6(name) => "La playlist \'${name}\' a été créée.";

  static String m7(selectedVal) =>
      "La playlist \'${selectedVal}\' contient déjà ce titre.";

  static String m8(selectedVal) =>
      "Le titre a été ajouté à la playlist \'${selectedVal}\'.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "album": MessageLookupByLibrary.simpleMessage("Album: "),
        "albumArtist": MessageLookupByLibrary.simpleMessage("Artist album: "),
        "artist": MessageLookupByLibrary.simpleMessage("Artiste: "),
        "backupRestore_backupFileNotCreated":
            MessageLookupByLibrary.simpleMessage(
                "Le fichier du backup n\'a pas pu être créé."),
        "backupRestore_error": MessageLookupByLibrary.simpleMessage("Erreur"),
        "backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain":
            MessageLookupByLibrary.simpleMessage(
                "Erreur de lecture du fichier.\nEssaie à nouveau."),
        "backupRestore_hasBeenUploadedToYourGoogleDrive":
            MessageLookupByLibrary.simpleMessage(
                " a été téléchargé sur ton Google Drive."),
        "backupRestore_noBackupFileSelected":
            MessageLookupByLibrary.simpleMessage(
                "Aucun fichier n\'a été sélectionné."),
        "backupRestore_pleaseTryAgain":
            MessageLookupByLibrary.simpleMessage("Essaie à nouveau."),
        "backupRestore_restoreAborted": MessageLookupByLibrary.simpleMessage(
            "Restauration des playlists interrompue."),
        "backupRestore_theFile":
            MessageLookupByLibrary.simpleMessage("Le fichier "),
        "backupRestore_theZipFileDoesNotContainValidPlaylistFilesExtension":
            MessageLookupByLibrary.simpleMessage(
                "Le fichier ZIP ne contient pas de fichiers playlists valables (extension: m3u)!"),
        "backupRestore_unableToUpload":
            MessageLookupByLibrary.simpleMessage("Échec du téléchargement:"),
        "backupRestore_wasSuccessfullyCreatedIn":
            MessageLookupByLibrary.simpleMessage(" a été créé dans "),
        "backupRestore_youAreNotSignedInToYourGoogleAccount":
            MessageLookupByLibrary.simpleMessage(
                "Tu n\'es pas enregistré dans ton compte Google"),
        "backupRestore_yourPlaylistsFromTheBackupFileHaveBeenRestored":
            MessageLookupByLibrary.simpleMessage(
                "Tes playlists ont été restaurées."),
        "buttonBackup": MessageLookupByLibrary.simpleMessage("Backup"),
        "buttonCancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "buttonContinue": MessageLookupByLibrary.simpleMessage("Continuer"),
        "buttonOk": MessageLookupByLibrary.simpleMessage("Ok"),
        "buttonRestore": MessageLookupByLibrary.simpleMessage("Restaurer"),
        "close": MessageLookupByLibrary.simpleMessage("Fermer"),
        "continuousPlaybackButton_ContinuousPlaybackIsOff":
            MessageLookupByLibrary.simpleMessage("Lecture continue désactivée"),
        "continuousPlaybackButton_ContinuousPlaybackIsOn":
            MessageLookupByLibrary.simpleMessage("Lecture continue activée"),
        "cutomWidgets_aZipArchiveWillBeCreatedAndUploaded":
            MessageLookupByLibrary.simpleMessage(
                "Un fichier ZIP sera créé puis téléchargé sur ton Google Drive"),
        "cutomWidgets_pickTheZipFileThatContainsYourBackup": m0,
        "duration": MessageLookupByLibrary.simpleMessage("Durée: "),
        "extraBar_clear": MessageLookupByLibrary.simpleMessage("Vider"),
        "extraBar_saveTheQueueAsAPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Sauvegarde la queue dans une nouvelle playlist: "),
        "extraBar_theQueueIsEmpty":
            MessageLookupByLibrary.simpleMessage("La queue est vide!"),
        "file": MessageLookupByLibrary.simpleMessage("Fichier: "),
        "files": MessageLookupByLibrary.simpleMessage("Fichiers"),
        "filterByPopUpMenuButton_album":
            MessageLookupByLibrary.simpleMessage("Album"),
        "filterByPopUpMenuButton_filter":
            MessageLookupByLibrary.simpleMessage("Filtrer"),
        "filterByPopUpMenuButton_year":
            MessageLookupByLibrary.simpleMessage("Année"),
        "genre": MessageLookupByLibrary.simpleMessage("Genre: "),
        "homePage_LoadingTracks":
            MessageLookupByLibrary.simpleMessage("Chargenent des titres ..."),
        "homePage_ScanningDevice":
            MessageLookupByLibrary.simpleMessage("Recherche de fichiers ..."),
        "initializeAwesomeNotification_allow":
            MessageLookupByLibrary.simpleMessage("Accepter"),
        "initializeAwesomeNotification_allowNotifications":
            MessageLookupByLibrary.simpleMessage("Accepte les notifications"),
        "initializeAwesomeNotification_dontAllow":
            MessageLookupByLibrary.simpleMessage("Refuser"),
        "initializeAwesomeNotification_ourAppWouldLikeToSendYouNotifications":
            MessageLookupByLibrary.simpleMessage(
                "L\'application voudrait afficher des notifications"),
        "listItemSlidable_remove":
            MessageLookupByLibrary.simpleMessage("Supprimer"),
        "listItemSlidable_theQueueAlreadyContainsThisTrack":
            MessageLookupByLibrary.simpleMessage(
                "la queue contient déjà ce titre."),
        "listItemSlidable_theTrackTracktracknameIsNowAddedToTheQueue": m1,
        "listItemSlidable_upsTheFileTrackfilepathWasNotFound": m2,
        "loopButton_LoopPlaybackIsOff":
            MessageLookupByLibrary.simpleMessage("Lecture en boucle activée"),
        "loopButton_LoopPlaybackIsOn": MessageLookupByLibrary.simpleMessage(
            "Lecture en boucle désactivée"),
        "playlistButton_SnackbarNameWasDeleted": m3,
        "playlistButton_ThisWillDefinitelyDeleteThePlaylist": m4,
        "playlistHandler_addThisTrackToPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Ajoute ce titre à la playlist: "),
        "playlistHandler_enterANameForYourNewPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Saisis un nom pour la nouvelle playlist!"),
        "playlistHandler_pick":
            MessageLookupByLibrary.simpleMessage("Sélection"),
        "playlistHandler_pickAPlaylist":
            MessageLookupByLibrary.simpleMessage("Choisis une playlist!"),
        "playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName":
            m5,
        "playlistHandler_thePlaylistNameWasCreated": m6,
        "playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack": m7,
        "playlistHandler_theTrackWasAddedToThePlaylistSelectedval": m8,
        "playlistHandler_youDontHaveAnyPlaylistYet":
            MessageLookupByLibrary.simpleMessage(
                "Tu n\'as pas encore de playlist!"),
        "playlistsMenu_NewPlaylist":
            MessageLookupByLibrary.simpleMessage("Nouvelle playlist: "),
        "queue": MessageLookupByLibrary.simpleMessage("Queue"),
        "save": MessageLookupByLibrary.simpleMessage("Sauvegarder"),
        "sortByDropdown_artist":
            MessageLookupByLibrary.simpleMessage("Artiste"),
        "sortByDropdown_creationDate":
            MessageLookupByLibrary.simpleMessage("Date creation"),
        "sortByDropdown_fileName":
            MessageLookupByLibrary.simpleMessage("Fichier"),
        "sortByDropdown_genre": MessageLookupByLibrary.simpleMessage("Genre"),
        "sortByDropdown_reset":
            MessageLookupByLibrary.simpleMessage("Rétablir"),
        "sortByDropdown_shuffle":
            MessageLookupByLibrary.simpleMessage("Mélanger"),
        "sortByDropdown_sort": MessageLookupByLibrary.simpleMessage("Trier"),
        "sortByDropdown_trackName":
            MessageLookupByLibrary.simpleMessage("Titre"),
        "track": MessageLookupByLibrary.simpleMessage("Titre: "),
        "trackNo": MessageLookupByLibrary.simpleMessage("No. titre: "),
        "year": MessageLookupByLibrary.simpleMessage("Année: ")
      };
}
