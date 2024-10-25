import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orangejam/application/extra_top_bar/sortby/sort_by_cubit.dart';

void main(){

  group("SortByCubit", (){
    late SortByCubit sortByCubit;

    setUp((){
      sortByCubit = SortByCubit();
    });

    tearDown((){
      sortByCubit.close();
    });


    blocTest<SortByCubit, String?>(
      "emits the provided string",
      build: () => sortByCubit,
      act: (cubit) => cubit.sortBy("name"),
      expect: () => ["name"],
    );
  });


}