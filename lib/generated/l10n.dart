// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Scanning device ...`
  String get homePage_ScanningDevice {
    return Intl.message(
      'Scanning device ...',
      name: 'homePage_ScanningDevice',
      desc: '',
      args: [],
    );
  }

  /// `Loading tracks ...`
  String get homePage_LoadingTracks {
    return Intl.message(
      'Loading tracks ...',
      name: 'homePage_LoadingTracks',
      desc: '',
      args: [],
    );
  }

  /// `New playlist: `
  String get playlistsMenu_NewPlaylist {
    return Intl.message(
      'New playlist: ',
      name: 'playlistsMenu_NewPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get buttonCancel {
    return Intl.message(
      'Cancel',
      name: 'buttonCancel',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get buttonOk {
    return Intl.message(
      'Ok',
      name: 'buttonOk',
      desc: '',
      args: [],
    );
  }

  /// `The playlist '{name}' was deleted.`
  String playlistButton_SnackbarNameWasDeleted(Object name) {
    return Intl.message(
      'The playlist \'$name\' was deleted.',
      name: 'playlistButton_SnackbarNameWasDeleted',
      desc: '',
      args: [name],
    );
  }

  /// `This will definitely delete the playlist: {name}`
  String playlistButton_ThisWillDefinitelyDeleteThePlaylist(Object name) {
    return Intl.message(
      'This will definitely delete the playlist: $name',
      name: 'playlistButton_ThisWillDefinitelyDeleteThePlaylist',
      desc: '',
      args: [name],
    );
  }

  /// `Files`
  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `Queue`
  String get queue {
    return Intl.message(
      'Queue',
      name: 'queue',
      desc: '',
      args: [],
    );
  }

  /// `Loop playback is off`
  String get loopButton_LoopPlaybackIsOff {
    return Intl.message(
      'Loop playback is off',
      name: 'loopButton_LoopPlaybackIsOff',
      desc: '',
      args: [],
    );
  }

  /// `Loop playback is on`
  String get loopButton_LoopPlaybackIsOn {
    return Intl.message(
      'Loop playback is on',
      name: 'loopButton_LoopPlaybackIsOn',
      desc: '',
      args: [],
    );
  }

  /// `Continuous playback is on`
  String get continuousPlaybackButton_ContinuousPlaybackIsOn {
    return Intl.message(
      'Continuous playback is on',
      name: 'continuousPlaybackButton_ContinuousPlaybackIsOn',
      desc: '',
      args: [],
    );
  }

  /// `Continuous playback is off`
  String get continuousPlaybackButton_ContinuousPlaybackIsOff {
    return Intl.message(
      'Continuous playback is off',
      name: 'continuousPlaybackButton_ContinuousPlaybackIsOff',
      desc: '',
      args: [],
    );
  }

  /// `Track: `
  String get track {
    return Intl.message(
      'Track: ',
      name: 'track',
      desc: '',
      args: [],
    );
  }

  /// `Artist: `
  String get artist {
    return Intl.message(
      'Artist: ',
      name: 'artist',
      desc: '',
      args: [],
    );
  }

  /// `Album: `
  String get album {
    return Intl.message(
      'Album: ',
      name: 'album',
      desc: '',
      args: [],
    );
  }

  /// `Album artist: `
  String get albumArtist {
    return Intl.message(
      'Album artist: ',
      name: 'albumArtist',
      desc: '',
      args: [],
    );
  }

  /// `Year: `
  String get year {
    return Intl.message(
      'Year: ',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Genre: `
  String get genre {
    return Intl.message(
      'Genre: ',
      name: 'genre',
      desc: '',
      args: [],
    );
  }

  /// `Track no: `
  String get trackNo {
    return Intl.message(
      'Track no: ',
      name: 'trackNo',
      desc: '',
      args: [],
    );
  }

  /// `Duration: `
  String get duration {
    return Intl.message(
      'Duration: ',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `File: `
  String get file {
    return Intl.message(
      'File: ',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `Ups, the file '{filePath}' was not found!`
  String listItemSlidable_upsTheFileTrackfilepathWasNotFound(Object filePath) {
    return Intl.message(
      'Ups, the file \'$filePath\' was not found!',
      name: 'listItemSlidable_upsTheFileTrackfilepathWasNotFound',
      desc: '',
      args: [filePath],
    );
  }

  /// `The track '{trackName}' is now added to the queue.`
  String listItemSlidable_theTrackTracktracknameIsNowAddedToTheQueue(
      Object trackName) {
    return Intl.message(
      'The track \'$trackName\' is now added to the queue.',
      name: 'listItemSlidable_theTrackTracktracknameIsNowAddedToTheQueue',
      desc: '',
      args: [trackName],
    );
  }

  /// `The queue already contains this track.`
  String get listItemSlidable_theQueueAlreadyContainsThisTrack {
    return Intl.message(
      'The queue already contains this track.',
      name: 'listItemSlidable_theQueueAlreadyContainsThisTrack',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get listItemSlidable_remove {
    return Intl.message(
      'Remove',
      name: 'listItemSlidable_remove',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get extraBar_clear {
    return Intl.message(
      'Clear',
      name: 'extraBar_clear',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Save the queue as a playlist:`
  String get extraBar_saveTheQueueAsAPlaylist {
    return Intl.message(
      'Save the queue as a playlist:',
      name: 'extraBar_saveTheQueueAsAPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `The queue is empty!`
  String get extraBar_theQueueIsEmpty {
    return Intl.message(
      'The queue is empty!',
      name: 'extraBar_theQueueIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Track name`
  String get sortByDropdown_trackName {
    return Intl.message(
      'Track name',
      name: 'sortByDropdown_trackName',
      desc: '',
      args: [],
    );
  }

  /// `File name`
  String get sortByDropdown_fileName {
    return Intl.message(
      'File name',
      name: 'sortByDropdown_fileName',
      desc: '',
      args: [],
    );
  }

  /// `Artist`
  String get sortByDropdown_artist {
    return Intl.message(
      'Artist',
      name: 'sortByDropdown_artist',
      desc: '',
      args: [],
    );
  }

  /// `Genre`
  String get sortByDropdown_genre {
    return Intl.message(
      'Genre',
      name: 'sortByDropdown_genre',
      desc: '',
      args: [],
    );
  }

  /// `Creation date`
  String get sortByDropdown_creationDate {
    return Intl.message(
      'Creation date',
      name: 'sortByDropdown_creationDate',
      desc: '',
      args: [],
    );
  }

  /// `Shuffle`
  String get sortByDropdown_shuffle {
    return Intl.message(
      'Shuffle',
      name: 'sortByDropdown_shuffle',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get sortByDropdown_reset {
    return Intl.message(
      'Reset',
      name: 'sortByDropdown_reset',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sortByDropdown_sort {
    return Intl.message(
      'Sort',
      name: 'sortByDropdown_sort',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get filterByPopUpMenuButton_album {
    return Intl.message(
      'Album',
      name: 'filterByPopUpMenuButton_album',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get filterByPopUpMenuButton_year {
    return Intl.message(
      'Year',
      name: 'filterByPopUpMenuButton_year',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filterByPopUpMenuButton_filter {
    return Intl.message(
      'Filter',
      name: 'filterByPopUpMenuButton_filter',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Pick the ZIP file that contains your backup in the '{appName} Playlists' folder in your Google Drive.`
  String cutomWidgets_pickTheZipFileThatContainsYourBackup(Object appName) {
    return Intl.message(
      'Pick the ZIP file that contains your backup in the \'$appName Playlists\' folder in your Google Drive.',
      name: 'cutomWidgets_pickTheZipFileThatContainsYourBackup',
      desc: '',
      args: [appName],
    );
  }

  /// `A ZIP archive will be created and uploaded to your Google Drive`
  String get cutomWidgets_aZipArchiveWillBeCreatedAndUploaded {
    return Intl.message(
      'A ZIP archive will be created and uploaded to your Google Drive',
      name: 'cutomWidgets_aZipArchiveWillBeCreatedAndUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get buttonContinue {
    return Intl.message(
      'Continue',
      name: 'buttonContinue',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get buttonRestore {
    return Intl.message(
      'Restore',
      name: 'buttonRestore',
      desc: '',
      args: [],
    );
  }

  /// `Backup`
  String get buttonBackup {
    return Intl.message(
      'Backup',
      name: 'buttonBackup',
      desc: '',
      args: [],
    );
  }

  /// `You are not signed in to your Google account`
  String get backupRestore_youAreNotSignedInToYourGoogleAccount {
    return Intl.message(
      'You are not signed in to your Google account',
      name: 'backupRestore_youAreNotSignedInToYourGoogleAccount',
      desc: '',
      args: [],
    );
  }

  /// `The file `
  String get backupRestore_theFile {
    return Intl.message(
      'The file ',
      name: 'backupRestore_theFile',
      desc: '',
      args: [],
    );
  }

  /// ` has been uploaded to your Google Drive.`
  String get backupRestore_hasBeenUploadedToYourGoogleDrive {
    return Intl.message(
      ' has been uploaded to your Google Drive.',
      name: 'backupRestore_hasBeenUploadedToYourGoogleDrive',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get backupRestore_error {
    return Intl.message(
      'Error',
      name: 'backupRestore_error',
      desc: '',
      args: [],
    );
  }

  /// `Backup file not created.`
  String get backupRestore_backupFileNotCreated {
    return Intl.message(
      'Backup file not created.',
      name: 'backupRestore_backupFileNotCreated',
      desc: '',
      args: [],
    );
  }

  /// `Please try again.`
  String get backupRestore_pleaseTryAgain {
    return Intl.message(
      'Please try again.',
      name: 'backupRestore_pleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// ` was successfully created in `
  String get backupRestore_wasSuccessfullyCreatedIn {
    return Intl.message(
      ' was successfully created in ',
      name: 'backupRestore_wasSuccessfullyCreatedIn',
      desc: '',
      args: [],
    );
  }

  /// `Unable to upload: `
  String get backupRestore_unableToUpload {
    return Intl.message(
      'Unable to upload: ',
      name: 'backupRestore_unableToUpload',
      desc: '',
      args: [],
    );
  }

  /// `No backup file selected.`
  String get backupRestore_noBackupFileSelected {
    return Intl.message(
      'No backup file selected.',
      name: 'backupRestore_noBackupFileSelected',
      desc: '',
      args: [],
    );
  }

  /// `Restore aborted.`
  String get backupRestore_restoreAborted {
    return Intl.message(
      'Restore aborted.',
      name: 'backupRestore_restoreAborted',
      desc: '',
      args: [],
    );
  }

  /// `The Zip file does not contain valid playlist files (extension: m3u) for this app!`
  String get backupRestore_theZipFileDoesNotContainValidPlaylistFilesExtension {
    return Intl.message(
      'The Zip file does not contain valid playlist files (extension: m3u) for this app!',
      name: 'backupRestore_theZipFileDoesNotContainValidPlaylistFilesExtension',
      desc: '',
      args: [],
    );
  }

  /// `Error while retrieving the backup file.\nPlease try again.`
  String get backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain {
    return Intl.message(
      'Error while retrieving the backup file.\nPlease try again.',
      name: 'backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Your playlists from the backup file have been restored.`
  String get backupRestore_yourPlaylistsFromTheBackupFileHaveBeenRestored {
    return Intl.message(
      'Your playlists from the backup file have been restored.',
      name: 'backupRestore_yourPlaylistsFromTheBackupFileHaveBeenRestored',
      desc: '',
      args: [],
    );
  }

  /// `Our app would like to send you notifications`
  String
      get initializeAwesomeNotification_ourAppWouldLikeToSendYouNotifications {
    return Intl.message(
      'Our app would like to send you notifications',
      name:
          'initializeAwesomeNotification_ourAppWouldLikeToSendYouNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Allow Notifications`
  String get initializeAwesomeNotification_allowNotifications {
    return Intl.message(
      'Allow Notifications',
      name: 'initializeAwesomeNotification_allowNotifications',
      desc: '',
      args: [],
    );
  }

  /// `The playlist '{name}' was created.`
  String playlistHandler_thePlaylistNameWasCreated(Object name) {
    return Intl.message(
      'The playlist \'$name\' was created.',
      name: 'playlistHandler_thePlaylistNameWasCreated',
      desc: '',
      args: [name],
    );
  }

  /// `The playlist '{name}' already exists.\nPlease choose another name.`
  String playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName(
      Object name) {
    return Intl.message(
      'The playlist \'$name\' already exists.\nPlease choose another name.',
      name:
          'playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName',
      desc: '',
      args: [name],
    );
  }

  /// `Enter a name for your new playlist!`
  String get playlistHandler_enterANameForYourNewPlaylist {
    return Intl.message(
      'Enter a name for your new playlist!',
      name: 'playlistHandler_enterANameForYourNewPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Add this track to playlist:`
  String get playlistHandler_addThisTrackToPlaylist {
    return Intl.message(
      'Add this track to playlist:',
      name: 'playlistHandler_addThisTrackToPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any playlist yet!`
  String get playlistHandler_youDontHaveAnyPlaylistYet {
    return Intl.message(
      'You don\'t have any playlist yet!',
      name: 'playlistHandler_youDontHaveAnyPlaylistYet',
      desc: '',
      args: [],
    );
  }

  /// `The track was added to the playlist '{selectedVal}'.`
  String playlistHandler_theTrackWasAddedToThePlaylistSelectedval(
      Object selectedVal) {
    return Intl.message(
      'The track was added to the playlist \'$selectedVal\'.',
      name: 'playlistHandler_theTrackWasAddedToThePlaylistSelectedval',
      desc: '',
      args: [selectedVal],
    );
  }

  /// `The playlist '{selectedVal}' already contains this track.`
  String playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack(
      Object selectedVal) {
    return Intl.message(
      'The playlist \'$selectedVal\' already contains this track.',
      name: 'playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack',
      desc: '',
      args: [selectedVal],
    );
  }

  /// `Pick a playlist!`
  String get playlistHandler_pickAPlaylist {
    return Intl.message(
      'Pick a playlist!',
      name: 'playlistHandler_pickAPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Pick`
  String get playlistHandler_pick {
    return Intl.message(
      'Pick',
      name: 'playlistHandler_pick',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get drawer_language {
    return Intl.message(
      'Language',
      name: 'drawer_language',
      desc: '',
      args: [],
    );
  }

  /// `Backup`
  String get drawer_backup {
    return Intl.message(
      'Backup',
      name: 'drawer_backup',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get drawer_restore {
    return Intl.message(
      'Restore',
      name: 'drawer_restore',
      desc: '',
      args: [],
    );
  }

  /// `Scan device`
  String get drawer_scanDevice {
    return Intl.message(
      'Scan device',
      name: 'drawer_scanDevice',
      desc: '',
      args: [],
    );
  }

  /// `Playlists`
  String get drawer_playlists {
    return Intl.message(
      'Playlists',
      name: 'drawer_playlists',
      desc: '',
      args: [],
    );
  }

  /// `Automatic playback\nof playlists`
  String get drawer_automaticPlayback {
    return Intl.message(
      'Automatic playback\nof playlists',
      name: 'drawer_automaticPlayback',
      desc: '',
      args: [],
    );
  }

  /// `Edit tags`
  String get edit_tags_editTags {
    return Intl.message(
      'Edit tags',
      name: 'edit_tags_editTags',
      desc: '',
      args: [],
    );
  }

  /// `Select\npicture`
  String get edit_tags_selectPicture {
    return Intl.message(
      'Select\npicture',
      name: 'edit_tags_selectPicture',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get edit_tags_trackTitle {
    return Intl.message(
      'Title',
      name: 'edit_tags_trackTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tracks total`
  String get edit_tags_tracksTotal {
    return Intl.message(
      'Tracks total',
      name: 'edit_tags_tracksTotal',
      desc: '',
      args: [],
    );
  }

  /// `The tags of {fileName} have been successfully updated.`
  String edit_tags_snackBarUpdateSuccess(Object fileName) {
    return Intl.message(
      'The tags of $fileName have been successfully updated.',
      name: 'edit_tags_snackBarUpdateSuccess',
      desc: '',
      args: [fileName],
    );
  }

  /// `An error occurred when writing to the file.\nCheck the file and try again.`
  String get edit_tags_snackBarUpdateError {
    return Intl.message(
      'An error occurred when writing to the file.\nCheck the file and try again.',
      name: 'edit_tags_snackBarUpdateError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
