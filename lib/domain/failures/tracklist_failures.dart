import 'package:equatable/equatable.dart';

abstract class TracklistFailure{}

class TracklistIoFailure extends TracklistFailure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class TracklistGeneralFailure extends TracklistFailure with EquatableMixin {
  @override
  List<Object?> get props => [];
}