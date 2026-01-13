import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nice_image/core/errors/errors.dart';
import 'package:nice_image/core/services/services.dart';
import 'package:nice_image/core/utils/utils.dart';
import 'package:nice_image/features/random_image/random_image.dart';

class MockRandomImageRepository extends Mock implements RandomImageRepository {}

class MockImagePaletteService extends Mock implements ImagePaletteService {}

void main() {
  late RandomImageCubit cubit;
  late MockRandomImageRepository mockRepository;
  late MockImagePaletteService mockPaletteService;

  setUp(() {
    mockRepository = MockRandomImageRepository();
    mockPaletteService = MockImagePaletteService();
    cubit = RandomImageCubit(mockRepository, mockPaletteService);
  });

  tearDown(() async {
    await cubit.close();
  });

  const testImage = RandomImage(url: 'https://example.com/image.jpg');
  const testColor = Colors.blue;

  group('RandomImageCubit', () {
    test('initial state is correct', () {
      expect(cubit.state.imageStatus.status, Status.initial);
      expect(cubit.state.backgroundColorStatus.status, Status.initial);
    });

    blocTest<RandomImageCubit, RandomImageState>(
      'emits [loading, success] when fetchRandomImage succeeds',
      build: () {
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => testImage);
        when(
          () => mockPaletteService.extractDominantColor(
            any(),
            brightness: any(named: 'brightness'),
          ),
        ).thenAnswer((_) async => testColor);
        return cubit;
      },
      act: (cubit) => cubit.fetchRandomImage(),
      expect: () => [
        RandomImageState(
          imageStatus: const ValueWrapper<RandomImage>().toLoading(),
          backgroundColorStatus: const ValueWrapper<Color>().toLoading(),
        ),
        RandomImageState(
          imageStatus: testImage.toSuccess(),
          backgroundColorStatus: testColor.toSuccess(),
        ),
      ],
    );

    blocTest<RandomImageCubit, RandomImageState>(
      'emits [loading, error] when fetchRandomImage fails',
      build: () {
        when(
          () => mockRepository.getRandomImage(),
        ).thenThrow(const NetworkException('Connection failed'));
        return cubit;
      },
      act: (cubit) => cubit.fetchRandomImage(),
      expect: () => [
        RandomImageState(
          imageStatus: const ValueWrapper<RandomImage>().toLoading(),
          backgroundColorStatus: const ValueWrapper<Color>().toLoading(),
        ),
        predicate<RandomImageState>((state) {
          return state.imageStatus.isError &&
              state.backgroundColorStatus.isError &&
              state.imageStatus.error!.message.toString().contains(
                'Connection failed',
              );
        }),
      ],
    );

    blocTest<RandomImageCubit, RandomImageState>(
      'preserves previous image while loading new one',
      build: () {
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => testImage);
        when(
          () => mockPaletteService.extractDominantColor(
            any(),
            brightness: any(named: 'brightness'),
          ),
        ).thenAnswer((_) async => testColor);
        return cubit;
      },
      seed: () => RandomImageState(
        imageStatus: testImage.toSuccess(),
        backgroundColorStatus: testColor.toSuccess(),
      ),
      act: (cubit) => cubit.fetchRandomImage(),
      expect: () => [
        RandomImageState(
          imageStatus: testImage.toLoading(),
          backgroundColorStatus: testColor.toLoading(),
        ),
        RandomImageState(
          imageStatus: testImage.toSuccess(),
          backgroundColorStatus: testColor.toSuccess(),
        ),
      ],
    );
  });
}
