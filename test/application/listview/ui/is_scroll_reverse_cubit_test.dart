import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orangejam/application/listview/ui/is_scroll_reverse_cubit.dart';

void main(){
  group("IsScrollReverseCubit", (){
    late IsScrollReverseCubit isScrollReverseCubit;

    setUp((){
      isScrollReverseCubit = IsScrollReverseCubit();
    });

    tearDown((){
      isScrollReverseCubit.close();
    });

    blocTest<IsScrollReverseCubit, bool?>(
      "emits true when setIsScrollReverse is called with true",
      build: () => isScrollReverseCubit,
      act: (cubit) => cubit.setIsScrollReverse(true),
      expect: () => [true],
    );

  });
}