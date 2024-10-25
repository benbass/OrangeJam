import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orangejam/application/listview/ui/is_scrolling_cubit.dart';

void main(){
  group("isScrollingCubit", (){
    late IsScrollingCubit isScrollingCubit;

    setUp((){
      isScrollingCubit = IsScrollingCubit();
    });

    tearDown((){
      isScrollingCubit.close();
    });

    blocTest<IsScrollingCubit, bool?>(
      "emits true when setIsScrolling is called with true",
      build: () => isScrollingCubit,
      act: (cubit) => cubit.setIsScrolling(true),
      expect: () => [true],
    );

  });
}