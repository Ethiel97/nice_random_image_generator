
import 'package:nice_image/features/random_image/domain/domain.dart';

/// Repository contract for fetching random images
/// ignore: one_member_abstracts
abstract class RandomImageRepository {
  /// Fetches a random image from the remote source
  Future<RandomImage> getRandomImage();
}
