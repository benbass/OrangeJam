import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:orangejam/application/language/language_cubit.dart';
import 'package:orangejam/core/globals.dart';

import 'generated/l10n.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import 'package:orangejam/core/player/audiohandler.dart';
import 'application/listview/ui/is_comm_with_google_cubit.dart';
import 'application/playercontrols/bloc/playercontrols_bloc.dart';
import 'injection.dart' as di;
import 'injection.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/playercontrols/cubits/loop_mode_cubit.dart';
import 'package:orangejam/application/extra_bar_all_files/sortby/sort_by_cubit.dart';
import 'package:orangejam/application/listview/tracklist/tracklist_bloc.dart';
import 'package:orangejam/presentation/homepage/homepage.dart';
import 'application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
import 'package:orangejam/application/playercontrols/cubits/track_duration_cubit.dart';
import 'package:orangejam/application/playercontrols/cubits/track_position_cubit.dart';
import 'application/listview/ui/is_scroll_reverse_cubit.dart';
import 'application/listview/ui/is_scrolling_cubit.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di.sl<MyAudioHandler>().flutterSoundPlayer.openPlayer();
  MetadataGod.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: appName,
      theme: AppTheme.lightTheme,
      home: MultiBlocProvider(
        providers: [
          /// App start processes are triggered by this bloc:
          /// permissions, data source, getting metadata from audio files and putting the whole via model into a track entity,
          /// saving track entities in database (objectBox), serving the list of track entities to UI
          BlocProvider(
            create: (BuildContext context) => sl<TracklistBloc>(),
          ),

          /// handles player controls
          BlocProvider(
            create: (BuildContext context) => sl<PlayerControlsBloc>(),
          ),

          /// handles event on playlists and on tracks within playlists (delete, sorting, filtering, moving...)
          BlocProvider(
            create: (BuildContext context) => sl<PlaylistsBloc>(),
          ),

          /// handles sortBy menu in extra bar
          BlocProvider(
            create: (BuildContext context) => SortByCubit(),
          ),
          /// handles list scrolling
          BlocProvider(
            create: (BuildContext context) => IsScrollingCubit(),
          ),

          /// handles list scrolling direction
          BlocProvider(
            create: (BuildContext context) => IsScrollReverseCubit(),
          ),

          /// handles progress bar in player controls
          BlocProvider(
            create: (BuildContext context) => TrackPositionCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => TrackDurationCubit(),
          ),

          /// handles loop playback mode
          BlocProvider(
            create: (BuildContext context) => LoopModeCubit(),
          ),

          /// handles continuous playback mode
          BlocProvider(
            create: (BuildContext context) => ContinuousPlaybackModeCubit(),
          ),

          /// handles filterBy menu in extra bar
          BlocProvider(
            create: (BuildContext context) => AppbarFilterByCubit(),
          ),

          /// handles waiting time when app communicates with Google Drive (restore or backup)
          BlocProvider(
            create: (BuildContext context) => IsCommWithGoogleCubit(),
          ),

          /// handles app language
          BlocProvider(
            create: (BuildContext context) => LanguageCubit(),
          ),
        ],
        child: const MyHomePage(),
      ),
    );
  }
}
