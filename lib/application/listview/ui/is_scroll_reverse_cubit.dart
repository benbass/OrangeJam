import 'package:bloc/bloc.dart';

class IsScrollReverseCubit extends Cubit<bool?> {
  IsScrollReverseCubit() : super(false);

  void setIsScrollReverse(bool isScrollReverse){
    emit(isScrollReverse);
  }
}
