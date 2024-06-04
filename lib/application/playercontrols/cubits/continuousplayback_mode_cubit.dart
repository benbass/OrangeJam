import 'package:bloc/bloc.dart';

class ContinuousPlaybackModeCubit extends Cubit<bool> {
  ContinuousPlaybackModeCubit() : super(false);

  void setContinuousPlaybackMode(bool continuousPlaybackMode){
    emit(continuousPlaybackMode);
  }
}
