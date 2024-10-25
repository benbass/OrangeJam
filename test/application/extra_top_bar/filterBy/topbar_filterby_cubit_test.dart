import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orangejam/application/extra_top_bar/filterby/topbar_filterby_cubit.dart';

void main() {
  group('TopBarFilterByCubit', () {
    late TopBarFilterByCubit topBarFilterByCubit;

    setUp(() {
      topBarFilterByCubit = TopBarFilterByCubit();
    });

    tearDown(() {
      topBarFilterByCubit.close();
    });

    blocTest<TopBarFilterByCubit, String?>(
      'emits null when setStringFilterBy is called with null',
      build: () => topBarFilterByCubit,
      act: (cubit) => cubit.setStringFilterBy(null),
      expect: () => [null],
      wait: const Duration(milliseconds: 600), // wait for Future is done
    );

    blocTest<TopBarFilterByCubit, String?>(
      'emits the provided string when state is null',
      build: () => topBarFilterByCubit,
      act: (cubit) => cubit.setStringFilterBy('Artist'),
      expect: () => ['Artist'],
      wait: const Duration(milliseconds: 600), // wait for Future is done
    );

    blocTest<TopBarFilterByCubit, String?>(
      'emits the concatenated string when state is not null',
      build: () => topBarFilterByCubit,
      seed: () => 'Album',
      act: (cubit) => cubit.setStringFilterBy('Artist'),
      expect: () => ['Album > Artist'],
      wait: const Duration(milliseconds: 600), // wait for Future is done
    );
  });
}