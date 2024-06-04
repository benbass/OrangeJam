import 'package:bloc/bloc.dart';

class LoopModeCubit extends Cubit<bool> {
  LoopModeCubit() : super(false);

  void setLoopMode(bool loopMode){
    emit(loopMode);
  }
}
