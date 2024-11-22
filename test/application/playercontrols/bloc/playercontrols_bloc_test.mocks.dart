// Mocks generated by Mockito 5.4.4 from annotations
// in orangejam/test/application/playercontrols/bloc/playercontrols_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:flutter/material.dart' as _i2;
import 'package:flutter_sound/flutter_sound.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:orangejam/core/player/audiohandler.dart' as _i5;
import 'package:orangejam/domain/entities/track_entity.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBuildContext_0 extends _i1.SmartFake implements _i2.BuildContext {
  _FakeBuildContext_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFlutterSoundPlayer_1 extends _i1.SmartFake
    implements _i3.FlutterSoundPlayer {
  _FakeFlutterSoundPlayer_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTrackEntity_2 extends _i1.SmartFake implements _i4.TrackEntity {
  _FakeTrackEntity_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDuration_3 extends _i1.SmartFake implements Duration {
  _FakeDuration_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MyAudioHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockMyAudioHandler extends _i1.Mock implements _i5.MyAudioHandler {
  MockMyAudioHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.BuildContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeBuildContext_0(
          this,
          Invocation.getter(#context),
        ),
      ) as _i2.BuildContext);

  @override
  _i3.FlutterSoundPlayer get flutterSoundPlayer => (super.noSuchMethod(
        Invocation.getter(#flutterSoundPlayer),
        returnValue: _FakeFlutterSoundPlayer_1(
          this,
          Invocation.getter(#flutterSoundPlayer),
        ),
      ) as _i3.FlutterSoundPlayer);

  @override
  set flutterSoundPlayer(_i3.FlutterSoundPlayer? _flutterSoundPlayer) =>
      super.noSuchMethod(
        Invocation.setter(
          #flutterSoundPlayer,
          _flutterSoundPlayer,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.TrackEntity get currentTrack => (super.noSuchMethod(
        Invocation.getter(#currentTrack),
        returnValue: _FakeTrackEntity_2(
          this,
          Invocation.getter(#currentTrack),
        ),
      ) as _i4.TrackEntity);

  @override
  set currentTrack(_i4.TrackEntity? _currentTrack) => super.noSuchMethod(
        Invocation.setter(
          #currentTrack,
          _currentTrack,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get isPausingState => (super.noSuchMethod(
        Invocation.getter(#isPausingState),
        returnValue: false,
      ) as bool);

  @override
  set isPausingState(bool? _isPausingState) => super.noSuchMethod(
        Invocation.setter(
          #isPausingState,
          _isPausingState,
        ),
        returnValueForMissingStub: null,
      );

  @override
  Duration get currentPosition => (super.noSuchMethod(
        Invocation.getter(#currentPosition),
        returnValue: _FakeDuration_3(
          this,
          Invocation.getter(#currentPosition),
        ),
      ) as Duration);

  @override
  set currentPosition(Duration? _currentPosition) => super.noSuchMethod(
        Invocation.setter(
          #currentPosition,
          _currentPosition,
        ),
        returnValueForMissingStub: null,
      );

  @override
  void openAudioSession() => super.noSuchMethod(
        Invocation.method(
          #openAudioSession,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void cancelNotification() => super.noSuchMethod(
        Invocation.method(
          #cancelNotification,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void playTrack(_i4.TrackEntity? track) => super.noSuchMethod(
        Invocation.method(
          #playTrack,
          [track],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void stopTrack() => super.noSuchMethod(
        Invocation.method(
          #stopTrack,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void pauseTrack() => super.noSuchMethod(
        Invocation.method(
          #pauseTrack,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void resumeTrack() => super.noSuchMethod(
        Invocation.method(
          #resumeTrack,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void gotoSeekPosition(Duration? seekPosition) => super.noSuchMethod(
        Invocation.method(
          #gotoSeekPosition,
          [seekPosition],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i6.Future<_i4.TrackEntity> getNextTrackAndPlay(
    int? direction,
    _i4.TrackEntity? currentTrack,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getNextTrackAndPlay,
          [
            direction,
            currentTrack,
          ],
        ),
        returnValue: _i6.Future<_i4.TrackEntity>.value(_FakeTrackEntity_2(
          this,
          Invocation.method(
            #getNextTrackAndPlay,
            [
              direction,
              currentTrack,
            ],
          ),
        )),
      ) as _i6.Future<_i4.TrackEntity>);
}