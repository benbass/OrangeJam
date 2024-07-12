import 'package:bloc/bloc.dart';

class AppbarFilterByCubit extends Cubit<String?> {
  AppbarFilterByCubit() : super(null);

  void setStringFilterBy(String? stringFilterby){
    String? output = "";
    if(stringFilterby == null){
      output = stringFilterby;
    } else if(state == null) {
      output = stringFilterby;
    } else {
      output = "${state!} > $stringFilterby";
    }
    Future.delayed(const Duration(milliseconds: 500), () => "1").then((value) => emit(output));

  }

}
