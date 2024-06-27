import 'package:bloc/bloc.dart';

class AscendingCubit extends Cubit<bool> {
  AscendingCubit() : super(true);

  void ascending(bool value) {
    emit(value);
  }
}
