import 'package:equatable/equatable.dart';

/// Domain entity representing a random image
class RandomImage extends Equatable {
  const RandomImage({required this.url});

  final String url;

  @override
  List<Object?> get props => [url];

  @override
  String toString() {
    return 'RandomImage(url: $url)';
  }
}
