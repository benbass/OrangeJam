import 'package:bloc/bloc.dart';

class SortByCubit extends Cubit<String?> {
  SortByCubit() : super('');

  void sortBy(String value) {
    emit(value);
  }

}
