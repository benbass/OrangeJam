import 'package:bloc/bloc.dart';

// we informs app about duration of current track
class TrackDurationCubit extends Cubit<Duration> {
  TrackDurationCubit() : super(const Duration(milliseconds: 0));

  void setDuration(Duration d){
    emit(d);
  }

}
