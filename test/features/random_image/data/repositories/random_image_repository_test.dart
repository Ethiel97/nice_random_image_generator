import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nice_image/features/random_image/random_image.dart';

class MockRandomImageRemoteDataSource extends Mock
    implements RandomImageRemoteDataSource {}

void main() {
  late RandomImageRepositoryImpl repository;
  late MockRandomImageRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRandomImageRemoteDataSource();
    repository = RandomImageRepositoryImpl(mockDataSource);
  });

  const testImageModel = RandomImageModel(
    url: 'https://example.com/image.jpg',
  );
  const testImageEntity = RandomImage(url: 'https://example.com/image.jpg');

  group('RandomImageRepositoryImpl', () {
    test(
      'getRandomImage returns RandomImage entity when datasource succeeds',
      () async {
        // Arrange
        when(
          () => mockDataSource.getRandomImage(),
        ).thenAnswer((_) async => testImageModel);

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, testImageEntity);
        expect(result, isA<RandomImage>());
        expect(result.url, testImageEntity.url);
        verify(() => mockDataSource.getRandomImage()).called(1);
      },
    );

    test('getRandomImage throws when datasource fails', () async {
      final exception = Exception('Network error');
      when(() => mockDataSource.getRandomImage()).thenThrow(exception);

      expect(
        () => repository.getRandomImage(),
        throwsA(exception),
      );
      verify(() => mockDataSource.getRandomImage()).called(1);
    });
  });
}
