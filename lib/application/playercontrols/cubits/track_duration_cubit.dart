import 'package:bloc/bloc.dart';

class TrackDurationCubit extends Cubit<Duration> {
  TrackDurationCubit() : super(const Duration(milliseconds: 0));

  void setDuration(Duration d){
    emit(d);
  }

}
