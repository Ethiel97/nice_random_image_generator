import 'package:flutter/material.dart';

/// Service for extracting dominant colors from images
/// ignore: one_member_abstracts
abstract class ImagePaletteService {
  /// Extracts the dominant color from an image URL
  Future<Color> extractDominantColor(
    String imageUrl, {
    Brightness? brightness,
  });
}
