import 'package:bloc/bloc.dart';

class IsCommWithGoogleCubit extends Cubit<bool> {
  IsCommWithGoogleCubit() : super(false);

  void isCommunicatingWithGoogleDrive(bool isCommunicating){
    emit(isCommunicating);
  }
}
