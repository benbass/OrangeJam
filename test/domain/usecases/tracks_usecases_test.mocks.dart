// Mocks generated by Mockito 5.4.4 from annotations
// in orangejam/test/domain/usecases/tracks_usecases_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:orangejam/domain/entities/track_entity.dart' as _i6;
import 'package:orangejam/domain/failures/tracks_failures.dart' as _i5;
import 'package:orangejam/domain/repositories/tracks_repository.dart' as _i3;

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

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TracksRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTracksRepository extends _i1.Mock implements _i3.TracksRepository {
  MockTracksRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.TracksFailure, List<_i6.TrackEntity>>>
      getTracksFromDevice() => (super.noSuchMethod(
            Invocation.method(
              #getTracksFromDevice,
              [],
            ),
            returnValue: _i4.Future<
                    _i2.Either<_i5.TracksFailure, List<_i6.TrackEntity>>>.value(
                _FakeEither_0<_i5.TracksFailure, List<_i6.TrackEntity>>(
              this,
              Invocation.method(
                #getTracksFromDevice,
                [],
              ),
            )),
          ) as _i4
              .Future<_i2.Either<_i5.TracksFailure, List<_i6.TrackEntity>>>);
}