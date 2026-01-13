import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_image/core/di/di.dart';
import 'package:nice_image/core/utils/utils.dart';
import 'package:nice_image/features/random_image/random_image.dart';
import 'package:nice_image/l10n/l10n.dart';

/// Main page for displaying random images
class RandomImagePage extends StatelessWidget {
  const RandomImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<RandomImageCubit>();
        unawaited(
          cubit.fetchRandomImage(
            brightness: Theme.of(context).brightness,
          ),
        );
        return cubit;
      },
      child: const RandomImageView(),
    );
  }
}

class RandomImageView extends StatelessWidget {
  const RandomImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocSelector<RandomImageCubit, RandomImageState, Color>(
            selector: (state) =>
                state.backgroundColorStatus.value ??
                Theme.of(context).colorScheme.surface,
            builder: (context, color) {
              return AnimatedBackground(color: color);
            },
          ),
          const SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: _ImageContent(),
                  ),
                ),
                _ActionButton(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget that displays the image content based on state
class _ImageContent extends StatelessWidget {
  const _ImageContent();

  @override
  Widget build(BuildContext context) {
    final imageStatus = context.select(
      (RandomImageCubit cubit) => cubit.state.imageStatus,
    );

    return imageStatus.when(
      initial: () => const LoadingIndicator(),
      loading: (oldValue) => oldValue != null
          ? _AdaptiveImageDisplay(imageUrl: oldValue.url)
          : const LoadingIndicator(),
      success: (image) => _AdaptiveImageDisplay(imageUrl: image.url),
      error: (errorDetails, _) => ErrorDisplay(
        errorDetails: errorDetails,
        onRetry: () => context.read<RandomImageCubit>().fetchRandomImage(
          brightness: Theme.of(context).brightness,
        ),
      ),
    );
  }
}

class _AdaptiveImageDisplay extends StatelessWidget {
  const _AdaptiveImageDisplay({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.8;
    final maxSize = MediaQuery.of(context).size.height * 0.6;
    final imageSize = size > maxSize ? maxSize : size;

    return ImageDisplay(
      imageUrl: imageUrl,
      size: imageSize,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (RandomImageCubit cubit) => cubit.state.isLoading,
    );
    final hasError = context.select(
      (RandomImageCubit cubit) => cubit.state.hasError,
    );
    final hasImage = context.select(
      (RandomImageCubit cubit) => cubit.state.imageStatus.value != null,
    );

    final l10n = context.l10n;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton(
          onPressed: isLoading || hasError
              ? null
              : () => context.read<RandomImageCubit>().fetchRandomImage(
                  brightness: Theme.of(context).brightness,
                ),
          style: FilledButton.styleFrom(
            backgroundColor: _getButtonColor(context),
            foregroundColor: _getButtonForegroundColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.3),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: isLoading
                ? Text(
                    key: ValueKey(l10n.loadingImage),
                    l10n.loadingImage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    hasImage ? l10n.another : l10n.generate,
                    key: ValueKey(hasImage ? l10n.another : l10n.generate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(BuildContext context) {
    final backgroundColor = context.select(
      (RandomImageCubit cubit) => cubit.state.backgroundColorStatus.value,
    );
    if (backgroundColor != null) {
      final luminance = backgroundColor.computeLuminance();
      return luminance > 0.5 ? Colors.black87 : Colors.white;
    }
    return Theme.of(context).colorScheme.primary;
  }

  Color _getButtonForegroundColor(BuildContext context) {
    final backgroundColor = context.select(
      (RandomImageCubit cubit) => cubit.state.backgroundColorStatus.value,
    );
    if (backgroundColor != null) {
      final luminance = backgroundColor.computeLuminance();
      return luminance > 0.5 ? Colors.white : Colors.black87;
    }
    return Theme.of(context).colorScheme.onPrimary;
  }
}
