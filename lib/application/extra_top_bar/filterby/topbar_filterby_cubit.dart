import 'package:bloc/bloc.dart';

class TopBarFilterByCubit extends Cubit<String?> {
  TopBarFilterByCubit() : super(null);

  void setStringFilterBy(String? stringFilterby){
    // Depending on current state we build an output == null or "String" or "String1 > String2 ..."
    // The output string will be display in the appBar (only on all tracks view)
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
