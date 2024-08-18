import 'package:bloc/bloc.dart';

class IsCommWithGoogleCubit extends Cubit<bool> {
  IsCommWithGoogleCubit() : super(false);

  // User is saving to or restoring from Google Drive his playlists: app shows a progress indicaator
  void isCommunicatingWithGoogleDrive(bool isCommunicating){
    emit(isCommunicating);
  }
}
