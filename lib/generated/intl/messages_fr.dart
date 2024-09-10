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
      "Choisissez le fichier ZIP qui contient le backup dans le dossier \'${appName} Playlists\' dans votre Google Drive.";

  static String m1(fileName) => "Les tags de ${fileName} ont été actualisés.";

  static String m2(trackName) =>
      "Le titre \'${trackName}\' a été ajouté à la queue.";

  static String m3(filePath) =>
      "Ups, le fichier \'${filePath}\' n\'existe pas!";

  static String m4(name) => "La playliste \'${name}\' a été supprimée.";

  static String m5(name) =>
      "La playliste \'${name}\' va être définitivement supprimée";

  static String m6(name) =>
      "La playliste \'${name}\' existe déjà.\nChoisissez un autre nom.";

  static String m7(name) => "La playliste \'${name}\' a été créée.";

  static String m8(selectedVal) =>
      "La playliste \'${selectedVal}\' contient déjà ce titre.";

  static String m9(selectedVal) =>
      "Le titre a été ajouté à la playliste \'${selectedVal}\'.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "album": MessageLookupByLibrary.simpleMessage("Album: "),
        "albumArtist": MessageLookupByLibrary.simpleMessage("Artiste album: "),
        "artist": MessageLookupByLibrary.simpleMessage("Artiste: "),
        "backupRestore_backupFileNotCreated":
            MessageLookupByLibrary.simpleMessage(
                "Le fichier du backup n\'a pas pu être créé."),
        "backupRestore_error": MessageLookupByLibrary.simpleMessage("Erreur"),
        "backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain":
            MessageLookupByLibrary.simpleMessage(
                "Erreur de lecture du fichier.\nEssayez à nouveau."),
        "backupRestore_hasBeenUploadedToYourGoogleDrive":
            MessageLookupByLibrary.simpleMessage(
                " a été téléchargé sur votre Google Drive."),
        "backupRestore_noBackupFileSelected":
            MessageLookupByLibrary.simpleMessage(
                "Aucun fichier n\'a été sélectionné."),
        "backupRestore_pleaseTryAgain":
            MessageLookupByLibrary.simpleMessage("Essayez à nouveau."),
        "backupRestore_restoreAborted": MessageLookupByLibrary.simpleMessage(
            "Restauration des playlistes interrompue."),
        "backupRestore_theFile":
            MessageLookupByLibrary.simpleMessage("Le fichier "),
        "backupRestore_theZipFileDoesNotContainValidPlaylistFilesExtension":
            MessageLookupByLibrary.simpleMessage(
                "Le fichier ZIP ne contient pas de fichiers playlistes valables (extension: m3u)!"),
        "backupRestore_unableToUpload":
            MessageLookupByLibrary.simpleMessage("Échec du téléchargement:"),
        "backupRestore_wasSuccessfullyCreatedIn":
            MessageLookupByLibrary.simpleMessage(" a été créé dans "),
        "backupRestore_youAreNotSignedInToYourGoogleAccount":
            MessageLookupByLibrary.simpleMessage(
                "Vous n\'êtes pas enregistré(e) dans votre compte Google"),
        "backupRestore_yourPlaylistsFromTheBackupFileHaveBeenRestored":
            MessageLookupByLibrary.simpleMessage(
                "Vos playlistes ont été restaurées."),
        "buttonBackup": MessageLookupByLibrary.simpleMessage("Backup"),
        "buttonCancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "buttonContinue": MessageLookupByLibrary.simpleMessage("Continuer"),
        "buttonOk": MessageLookupByLibrary.simpleMessage("Ok"),
        "buttonRestore": MessageLookupByLibrary.simpleMessage("Restaurer"),
        "close": MessageLookupByLibrary.simpleMessage("Fermer"),
        "cutomWidgets_aZipArchiveWillBeCreatedAndUploaded":
            MessageLookupByLibrary.simpleMessage(
                "Un fichier ZIP sera créé puis téléchargé sur votre Google Drive"),
        "cutomWidgets_pickTheZipFileThatContainsYourBackup": m0,
        "drawer_automaticPlayback":
            MessageLookupByLibrary.simpleMessage("Lecture automatique"),
        "drawer_backup": MessageLookupByLibrary.simpleMessage("Backup"),
        "drawer_language": MessageLookupByLibrary.simpleMessage("Langue"),
        "drawer_playlists": MessageLookupByLibrary.simpleMessage("Playlistes"),
        "drawer_restore": MessageLookupByLibrary.simpleMessage("Restaurer"),
        "drawer_scanDevice": MessageLookupByLibrary.simpleMessage(
            "Rafraîchir\nla base de données"),
        "duration": MessageLookupByLibrary.simpleMessage("Durée: "),
        "edit_tags_editTags":
            MessageLookupByLibrary.simpleMessage("Éditer les tags"),
        "edit_tags_selectPicture":
            MessageLookupByLibrary.simpleMessage("Choisir\nimage"),
        "edit_tags_snackBarUpdateError": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite lors de l\'écriture dans le fichier.\nVérifiez le fichier et essayez à nouveau."),
        "edit_tags_snackBarUpdateSuccess": m1,
        "edit_tags_trackTitle": MessageLookupByLibrary.simpleMessage("Titre"),
        "edit_tags_tracksTotal":
            MessageLookupByLibrary.simpleMessage("Total de titres"),
        "extraBar_clear": MessageLookupByLibrary.simpleMessage("Vider"),
        "extraBar_saveTheQueueAsAPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Sauvegardez la queue dans une nouvelle playliste: "),
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
        "help": MessageLookupByLibrary.simpleMessage("Aide"),
        "help_add_to_playlist": MessageLookupByLibrary.simpleMessage(
            "Ajouter à\nune playliste /\nla queue"),
        "help_add_to_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Balayez le titre vers la droite et choisissez l\'option désirée."),
        "help_automatic_playback":
            MessageLookupByLibrary.simpleMessage("Lecture\nautomatique"),
        "help_automatic_playback_desc": MessageLookupByLibrary.simpleMessage(
            "Activez ce mode dans le menu des paramètres.\nVeuillez noter qu\'une liste n\'est pas lancée automatiquement lorsque vous démarrez l\'application.\nLe mode ne fonctionne que lorsque vous passez à une autre liste."),
        "help_backup_restore": MessageLookupByLibrary.simpleMessage(
            "Backup &\nRestauration\ndes playlistes"),
        "help_backup_restore_desc": MessageLookupByLibrary.simpleMessage(
            "Pendant la sauvegarde, un fichier d\'archive (zip) est téléchargé sur votre Google Drive. Vous devez être connecté à votre compte Google.\n\nLors de la restauration, vous serez invité à sélectionner un fichier d\'archive précédemment créé dans votre Google Drive.\nLes playlistes restaurées sont ajoutées aux playlistes existantes. Si des playlistes portant le même nom existent déjà dans l\'application, elles seront écrasées."),
        "help_create_playlist":
            MessageLookupByLibrary.simpleMessage("Créer une\nplayliste"),
        "help_create_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Tapez sur le bouton \'OrangeJam\' au bas de l\'application, puis sur le bouton \'+\'."),
        "help_delete_playlist":
            MessageLookupByLibrary.simpleMessage("Supprimer une\nplayliste"),
        "help_delete_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Tapez sur le bouton \'OrangeJam\' au bas de l\'application, puis appuyez longuement sur le bouton de la playliste à supprimer."),
        "help_edit_tags":
            MessageLookupByLibrary.simpleMessage("Modifier\nles tags"),
        "help_edit_tags_desc": MessageLookupByLibrary.simpleMessage(
            "Balayez le titre vers la gauche ou tapez sur le bouton \'Editer\' dans les commandes du lecteur.\nCette dernière option n\'est disponible que pour le titre en cours de lecture."),
        "help_or": MessageLookupByLibrary.simpleMessage(" ou "),
        "help_play": MessageLookupByLibrary.simpleMessage("Lecture"),
        "help_play_desc":
            MessageLookupByLibrary.simpleMessage("Tapez sur le titre"),
        "help_refresh": MessageLookupByLibrary.simpleMessage(
            "Rafraîchir\nla base de\ndonnées"),
        "help_refresh_desc": MessageLookupByLibrary.simpleMessage(
            "Après avoir supprimé ou ajouté des fichiers audio à votre bibliothèque musicale (à l\'aide d\'une application de gestion de fichiers), vous devez mettre à jour la base de données afin qu\'elle reflète l\'état actuel de votre bibliothèque."),
        "help_remove_from_playlist": MessageLookupByLibrary.simpleMessage(
            "Supprimer d\'une\nplayliste /\nde la queue"),
        "help_remove_from_playlist_desc": MessageLookupByLibrary.simpleMessage(
            "Balayez le titre vers la gauche et supprimez-le.\nCela supprime immédiatement le titre et, dans le cas d\'une playliste, enregistre le nouveau statut de cette playliste.\nNotez que cette option n\'est pas disponible pour la liste \'Fichiers\', car l\'application ne peut supprimer que des éléments des playlistes : Elle ne peut pas supprimer de fichiers.\nSi vous souhaitez supprimer un fichier de votre appareil, utilisez l\'application de gestion de fichiers de votre choix. Lorsque vous avez terminé, allez dans les paramètres de l\'application et scannez votre appareil afin de mettre à jour la base de données.\n"),
        "help_reorder_tracks":
            MessageLookupByLibrary.simpleMessage("Réordonner les titres"),
        "help_reorder_tracks_desc": MessageLookupByLibrary.simpleMessage(
            "Appuyez longuement sur le titre et faites-le glisser dans la nouvelle position.\nNotez que le nouvel ordre sera immédiatement sauvegardé pour les playlistes. Pour les \'Fichiers\' et la \'Queue\' l\'ordre sera perdu lorsque vous ouvrirez une autre liste."),
        "help_repeat_track":
            MessageLookupByLibrary.simpleMessage("Répéter\nun titre"),
        "help_repeat_track_desc": MessageLookupByLibrary.simpleMessage(
            "Tapez sur le bouton \'Lecture en boucle\' dans les commandes du lecteur."),
        "help_shuffle": MessageLookupByLibrary.simpleMessage("Mélanger"),
        "help_shuffle_desc": MessageLookupByLibrary.simpleMessage(
            "Tapez sur le bouton \'Mélanger\' dans les commandes du lecteur."),
        "help_stop": MessageLookupByLibrary.simpleMessage("Stopper"),
        "help_stop_desc": MessageLookupByLibrary.simpleMessage(
            "Tapez à nouveau sur le titre OU tapez sur le bouton \'Stop\' dans les commandes du lecteur."),
        "help_view_tags":
            MessageLookupByLibrary.simpleMessage("Afficher\nles tags"),
        "help_view_tags_desc": MessageLookupByLibrary.simpleMessage(
            "Tapez sur le bouton \'Info\' dans les commandes du lecteur.\nCette fonction n\'est disponible que lorsqu\'un titre est en cours de lecture."),
        "homePage_LoadingTracks":
            MessageLookupByLibrary.simpleMessage("Chargenent des titres ..."),
        "homePage_ScanningDevice":
            MessageLookupByLibrary.simpleMessage("Recherche de fichiers ..."),
        "initializeAwesomeNotification_allowNotifications":
            MessageLookupByLibrary.simpleMessage("Acceptez les notifications"),
        "initializeAwesomeNotification_ourAppWouldLikeToSendYouNotifications":
            MessageLookupByLibrary.simpleMessage(
                "L\'application voudrait afficher des notifications"),
        "listItemSlidable_remove":
            MessageLookupByLibrary.simpleMessage("Supprimer"),
        "listItemSlidable_theQueueAlreadyContainsThisTrack":
            MessageLookupByLibrary.simpleMessage(
                "la queue contient déjà ce titre."),
        "listItemSlidable_theTrackTracktracknameIsNowAddedToTheQueue": m2,
        "listItemSlidable_upsTheFileTrackfilepathWasNotFound": m3,
        "loopButton_LoopPlaybackIsOff": MessageLookupByLibrary.simpleMessage(
            "Lecture en boucle désactivée"),
        "loopButton_LoopPlaybackIsOn":
            MessageLookupByLibrary.simpleMessage("Lecture en boucle activée"),
        "playlistButton_SnackbarNameWasDeleted": m4,
        "playlistButton_ThisWillDefinitelyDeleteThePlaylist": m5,
        "playlistHandler_addThisTrackToPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Ajoutez ce titre à la playliste: "),
        "playlistHandler_enterANameForYourNewPlaylist":
            MessageLookupByLibrary.simpleMessage(
                "Saisissez un nom pour la nouvelle playliste!"),
        "playlistHandler_pick":
            MessageLookupByLibrary.simpleMessage("Sélection"),
        "playlistHandler_pickAPlaylist":
            MessageLookupByLibrary.simpleMessage("Choisissez une playliste!"),
        "playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName":
            m6,
        "playlistHandler_thePlaylistNameWasCreated": m7,
        "playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack": m8,
        "playlistHandler_theTrackWasAddedToThePlaylistSelectedval": m9,
        "playlistHandler_youDontHaveAnyPlaylistYet":
            MessageLookupByLibrary.simpleMessage(
                "Vous n\'avez pas encore de playliste!"),
        "playlistsMenu_NewPlaylist":
            MessageLookupByLibrary.simpleMessage("Nouvelle playliste: "),
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
