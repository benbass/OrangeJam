import 'package:bloc/bloc.dart';

class TrackPositionCubit extends Cubit<Duration?> {
  TrackPositionCubit() : super(null);

  void setPosition(Duration p){
    emit(p);
  }

}
