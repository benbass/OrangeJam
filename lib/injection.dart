import 'package:get_it/get_it.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/core/objectbox.dart';
import 'package:orangejam/domain/repositories/playlists_repository.dart';
import 'package:orangejam/domain/repositories/tracks_repository.dart';
import 'package:orangejam/domain/usecases/playlists_usecases.dart';
import 'package:orangejam/domain/usecases/tracks_usecases.dart';
import 'package:orangejam/infrastructure/datasources/audiofiles_datasources.dart';
import 'package:orangejam/infrastructure/datasources/playlists_datasource.dart';
import 'package:orangejam/infrastructure/datasources/tracks_datasources.dart';
import 'package:orangejam/core/metatags/metatags_handler.dart';
import 'package:orangejam/infrastructure/repositories/playlists_repository_impl.dart';
import 'package:orangejam/infrastructure/repositories/tracks_repository_impl.dart';
import 'package:orangejam/services/audio_session.dart';
import 'package:orangejam/core/player/audiohandler.dart';

import 'application/listview/data/tracks_bloc.dart';
import 'application/playercontrols/bloc/playercontrols_bloc.dart';
import 'domain/entities/track_entity.dart';
import 'objectbox.g.dart';

final sl = GetIt.instance; // sl = service locator (injection container)
late Box<TrackEntity> trackBox;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => TracksBloc(tracksUsecase: sl()));
  sl.registerFactory(() => PlaylistsBloc(playlistsUsecases: sl()));
  // Usecases
  sl.registerLazySingleton(() => TracksUsecases(tracksRepository: sl()));
  sl.registerLazySingleton(() => PlaylistsUsecases(playlistsRepository: sl()));
  // Repos
  sl.registerLazySingleton<TracksRepository>(
      () => TracksRepositoryImpl(tracksDataSources: sl()));
  sl.registerLazySingleton<PlaylistsRepository>(
      () => PlaylistsRepositoryImpl(playlistsDatasource: sl()));
  // Datasources
  sl.registerLazySingleton<TracksDatasource>(
      () => TracksDatasourceImpl(audioFilesDataSources: sl()));

  /// Provides access to the ObjectBox Store throughout the app.
  ObjectBox objectbox = await ObjectBox.create();
  trackBox = objectbox.store.box<TrackEntity>();
  sl.registerSingleton(() => trackBox);
  // Intern
  sl.registerLazySingleton<AudioFilesDataSources>(
      () => AudioFilesDataSourcesImpl());
  sl.registerLazySingleton<Playlistsdatasource>(
      () => PlaylistsDatasourceImpl());

  final metaTagsHandler = MetaTagsHandler();
  sl.registerLazySingleton<MetaTagsHandler>(() => metaTagsHandler);

  final audioHandler = MyAudioHandler();
  sl.registerLazySingleton<MyAudioHandler>(() => audioHandler);

  final audioSession = MyAudioSession();
  sl.registerLazySingleton<MyAudioSession>(() => audioSession);
  // state management
  final playerControls = PlayerControlsBloc();
  sl.registerLazySingleton(() => playerControls);
  //sl.registerFactory(() => PlayerControlsBloc());
}
