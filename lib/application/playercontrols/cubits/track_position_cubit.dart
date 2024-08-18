import 'package:bloc/bloc.dart';

// we informs app about position of current track for progress
class TrackPositionCubit extends Cubit<Duration?> {
  TrackPositionCubit() : super(null);

  void setPosition(Duration p){
    emit(p);
  }

}
