import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orangejam/application/listview/ui/is_comm_with_google_cubit.dart';

void main(){
  group("IsCommWithGoogleCubit", (){
    late IsCommWithGoogleCubit isCommWithGoogleCubit;

    setUp((){
      isCommWithGoogleCubit = IsCommWithGoogleCubit();
    });

    tearDown((){
      isCommWithGoogleCubit.close();
    });

    blocTest<IsCommWithGoogleCubit, bool>(
        "emits true when isCommunicatingWithGoogleDrive is called with true",
        build: () => isCommWithGoogleCubit,
    act: (cubit) => cubit.isCommunicatingWithGoogleDrive(true),
    expect: () => [true],
    );

  });
}