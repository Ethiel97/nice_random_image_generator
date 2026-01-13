import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nice_image/core/errors/errors.dart';
import 'package:nice_image/core/services/services.dart';
import 'package:nice_image/core/utils/utils.dart';
import 'package:nice_image/features/random_image/domain/domain.dart';
import 'package:nice_image/features/random_image/presentation/presentation.dart';

@injectable
class RandomImageCubit extends Cubit<RandomImageState> {
  RandomImageCubit(
    this._repository,
    this._paletteService,
  ) : super(const RandomImageState());

  final RandomImageRepository _repository;
  final ImagePaletteService _paletteService;

  Future<void> initialize() async {}

  /// Fetches a new random image and extracts its dominant color
  Future<void> fetchRandomImage({Brightness? brightness}) async {
    try {
      //if already loading, do nothing
      if (state.imageStatus.isLoading ||
          state.backgroundColorStatus.isLoading) {
        return;
      }

      emit(
        state.copyWith(
          imageStatus: state.imageStatus.toLoading(),
          backgroundColorStatus: state.backgroundColorStatus.toLoading(),
        ),
      );

      final image = await _repository.getRandomImage();

      emit(
        state.copyWith(
          imageStatus: image.toSuccess(),
        ),
      );

      final color = await _paletteService.extractDominantColor(
        image.url,
        brightness: brightness,
      );

      emit(
        state.copyWith(
          backgroundColorStatus: color.toSuccess(),
        ),
      );
    } on AppException catch (e) {
      final errorDetails = ErrorDetails(
        message: e.message,
        stackTrace: e.details?.stackTrace,
      );
      emit(
        state.copyWith(
          imageStatus: state.imageStatus.toError(errorDetails),
          backgroundColorStatus: state.backgroundColorStatus.toError(
            errorDetails,
          ),
        ),
      );
    } on Exception catch (e, stackTrace) {
      final errorDetails = ErrorDetails(
        message: 'Failed to fetch image: $e',
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          imageStatus: state.imageStatus.toError(errorDetails),
          backgroundColorStatus: state.backgroundColorStatus.toError(
            errorDetails,
          ),
        ),
      );
    }
  }
}
