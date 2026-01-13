import 'package:equatable/equatable.dart';
import 'package:nice_image/features/random_image/domain/domain.dart';

/// Data model for random image with JSON serialization
class RandomImageModel extends Equatable {
  const RandomImageModel({required this.url});

  /// Creates a model from a domain entity
  factory RandomImageModel.fromEntity(RandomImage entity) {
    return RandomImageModel(url: entity.url);
  }

  /// Creates a model from JSON
  factory RandomImageModel.fromJson(Map<String, dynamic> json) {
    return RandomImageModel(
      url: json['url'] as String,
    );
  }

  final String url;

  /// Converts model to JSON
  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }

  /// Converts model to domain entity
  RandomImage toEntity() {
    return RandomImage(url: url);
  }

  @override
  List<Object?> get props => [url];
}
