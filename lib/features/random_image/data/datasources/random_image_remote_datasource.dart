import 'package:injectable/injectable.dart';
import 'package:nice_image/core/errors/errors.dart';
import 'package:nice_image/core/network/network.dart';
import 'package:nice_image/core/utils/utils.dart';
import 'package:nice_image/features/random_image/data/data.dart';

/// Remote data source for fetching random images
/// ignore: one_member_abstracts
abstract class RandomImageRemoteDataSource {
  Future<RandomImageModel> getRandomImage();
}

@LazySingleton(as: RandomImageRemoteDataSource)
class RandomImageRemoteDataSourceImpl implements RandomImageRemoteDataSource {
  RandomImageRemoteDataSourceImpl(this._httpClient);

  final HttpClient _httpClient;

  @override
  Future<RandomImageModel> getRandomImage() async {
    try {
      final response = await _httpClient.get('/image');
      return RandomImageModel.fromJson(response);
    } catch (e, stackTrace) {
      if (e is AppException) rethrow;

      throw DataException(
        'Failed to parse image data',
        ErrorDetails(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }
}
