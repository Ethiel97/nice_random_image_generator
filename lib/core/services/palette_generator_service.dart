import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nice_image/core/services/services.dart';
import 'package:palette_generator/palette_generator.dart';

@LazySingleton(as: ImagePaletteService)
class PaletteGeneratorService implements ImagePaletteService {
  @override
  Future<Color> extractDominantColor(
    String imageUrl, {
    Brightness? brightness,
  }) async {
    try {
      final imageProvider = NetworkImage(imageUrl);
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        imageProvider,
        maximumColorCount: 20,
      );

      Color? dominantColor;
      if (brightness == Brightness.dark) {
        dominantColor =
            paletteGenerator.darkVibrantColor?.color ??
            paletteGenerator.darkMutedColor?.color;
      } else if (brightness == Brightness.light) {
        dominantColor =
            paletteGenerator.lightVibrantColor?.color ??
            paletteGenerator.lightMutedColor?.color;
      }

      // Fallback to vibrant or dominant color
      dominantColor ??=
          paletteGenerator.vibrantColor?.color ??
          paletteGenerator.dominantColor?.color ??
          _getDefaultColor(brightness);

      // Ensure sufficient contrast
      return _ensureContrast(dominantColor, brightness);
    } on Exception catch (_) {
      return _getDefaultColor(brightness);
    }
  }

  Color _getDefaultColor(Brightness? brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF5F5F5);
  }

  Color _ensureContrast(Color color, Brightness? brightness) {
    final luminance = color.computeLuminance();

    if (brightness == Brightness.dark && luminance > 0.5) {
      return Color.lerp(color, Colors.black, 0.5) ?? color;
    }

    if (brightness == Brightness.light && luminance < 0.3) {
      return Color.lerp(color, Colors.white, 0.5) ?? color;
    }

    return color;
  }
}
