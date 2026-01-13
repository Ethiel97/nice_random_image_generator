import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nice_image/core/utils/utils.dart';
import 'package:nice_image/features/random_image/domain/domain.dart';

/// State for the random image feature
class RandomImageState extends Equatable {
  const RandomImageState({
    this.backgroundColorStatus = const ValueWrapper(),
    this.imageStatus = const ValueWrapper(),
  });

  final ValueWrapper<Color> backgroundColorStatus;
  final ValueWrapper<RandomImage> imageStatus;

  RandomImageState copyWith({
    ValueWrapper<Color>? backgroundColorStatus,
    ValueWrapper<RandomImage>? imageStatus,
  }) {
    return RandomImageState(
      backgroundColorStatus:
          backgroundColorStatus ?? this.backgroundColorStatus,
      imageStatus: imageStatus ?? this.imageStatus,
    );
  }

  bool get hasError => backgroundColorStatus.isError || imageStatus.isError;

  bool get isLoading =>
      backgroundColorStatus.isLoading || imageStatus.isLoading;

  @override
  List<Object?> get props => [
    backgroundColorStatus,
    imageStatus,
  ];
}
