import 'package:bloc/bloc.dart';

class IsScrollingCubit extends Cubit<bool?> {
  IsScrollingCubit() : super(false);

  void setIsScrolling(bool isScrolling){
    emit(isScrolling);
  }
}
