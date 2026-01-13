import 'package:injectable/injectable.dart';
import 'package:nice_image/features/random_image/data/data.dart';
import 'package:nice_image/features/random_image/domain/domain.dart';

@LazySingleton(as: RandomImageRepository)
class RandomImageRepositoryImpl implements RandomImageRepository {
  RandomImageRepositoryImpl(this._remoteDataSource);

  final RandomImageRemoteDataSource _remoteDataSource;

  @override
  Future<RandomImage> getRandomImage() async {
    try {
      final model = await _remoteDataSource.getRandomImage();
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
