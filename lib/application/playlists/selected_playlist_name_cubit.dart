import 'package:bloc/bloc.dart';

class SelectedPlaylistNameCubit extends Cubit<String> {
  SelectedPlaylistNameCubit() : super("");

  // we set the name of the selected playlist in dropdown menu (add track to playlist)
  void setName(String name) async {
    emit(name);
  }

}
