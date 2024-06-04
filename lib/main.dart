import 'package:flutter/material.dart';
import 'package:orange_player/application/bottombar/playlists/playlists_bloc.dart';
import 'package:orange_player/application/my_listview/ui/appbar_filterby_cubit.dart';
import 'package:orange_player/core/audiohandler.dart';
import 'application/bottombar/playlists/is_comm_with_google_cubit.dart';
import 'application/playercontrols/bloc/playercontrols_bloc.dart';
import 'injection.dart' as di;
import 'injection.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/playercontrols/cubits/loop_mode_cubit.dart';
import 'package:orange_player/application/my_listview/sortby/ascending_cubit.dart';
import 'package:orange_player/application/my_listview/sortby/sort_by_cubit.dart';
import 'package:orange_player/application/my_listview/tracklist/tracklist_bloc.dart';
import 'package:orange_player/presentation/homepage/homepage.dart';
import 'application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
import 'package:orange_player/application/playercontrols/cubits/track_duration_cubit.dart';
import 'package:orange_player/application/playercontrols/cubits/track_position_cubit.dart';
import 'application/my_listview/ui/is_scroll_reverse_cubit.dart';
import 'application/my_listview/ui/is_scrolling_cubit.dart';
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
      title: 'The Orange Player',
      theme: AppTheme.lightTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => sl<TracklistBloc>(),
          ),
          BlocProvider(
            create: (BuildContext context) => sl<PlayerControlsBloc>(),
          ),
          BlocProvider(
            create: (BuildContext context) => sl<PlaylistsBloc>(),
          ),
          BlocProvider(
            create: (BuildContext context) => SortByCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => AscendingCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => IsScrollingCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => IsScrollReverseCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => TrackPositionCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => TrackDurationCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => LoopModeCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => ContinuousPlaybackModeCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => AppbarFilterByCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => IsCommWithGoogleCubit(),
          ),
        ],
        child: const MyHomePage(),
      ),
    );
  }
}
