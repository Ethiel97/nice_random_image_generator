import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nice_image/core/utils/utils.dart';
import 'package:nice_image/features/random_image/random_image.dart';

class MockRandomImageCubit extends Mock implements RandomImageCubit {}

void main() {
  late MockRandomImageCubit mockCubit;

  setUp(() {
    mockCubit = MockRandomImageCubit();
  });

  const testImage = RandomImage(url: 'https://example.com/image.jpg');
  const testColor = Colors.blue;

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<RandomImageCubit>.value(
        value: mockCubit,
        child: const RandomImageView(),
      ),
    );
  }

  group('RandomImagePage', () {
    testWidgets('displays loading indicator when state is loading', (
      tester,
    ) async {
      when(() => mockCubit.state).thenReturn(
        RandomImageState(
          imageStatus: const ValueWrapper<RandomImage>().toLoading(),
          backgroundColorStatus: const ValueWrapper<Color>().toLoading(),
        ),
      );
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestableWidget());

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.text('Another'), findsNothing);
    });

    testWidgets('displays image when state is success', (tester) async {
      when(() => mockCubit.state).thenReturn(
        RandomImageState(
          imageStatus: testImage.toSuccess(),
          backgroundColorStatus: testColor.toSuccess(),
        ),
      );
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(find.text('Another'), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);
    });

    testWidgets('displays error widget when state is error', (
      tester,
    ) async {
      const errorDetails = ErrorDetails(message: 'Test error');
      when(() => mockCubit.state).thenReturn(
        RandomImageState(
          imageStatus: const ValueWrapper<RandomImage>().toError(errorDetails),
          backgroundColorStatus: const ValueWrapper<Color>().toError(
            errorDetails,
          ),
        ),
      );
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(find.text('Test error'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets(
      'calls fetchRandomImage when Another button is pressed',
      (tester) async {
        when(() => mockCubit.state).thenReturn(
          RandomImageState(
            imageStatus: testImage.toSuccess(),
            backgroundColorStatus: testColor.toSuccess(),
          ),
        );
        when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
        when(
          () => mockCubit.fetchRandomImage(
            brightness: any(named: 'brightness'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(makeTestableWidget());
        await tester.pump();
        await tester.tap(find.text('Another'));

        verify(
          () =>
              mockCubit.fetchRandomImage(brightness: any(named: 'brightness')),
        ).called(1);
      },
    );
  });
}
