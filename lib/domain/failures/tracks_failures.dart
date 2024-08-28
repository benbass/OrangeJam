import 'package:equatable/equatable.dart';

abstract class TracksFailure{}

class TracksIoFailure extends TracksFailure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class TracksGeneralFailure extends TracksFailure with EquatableMixin {
  @override
  List<Object?> get props => [];
}