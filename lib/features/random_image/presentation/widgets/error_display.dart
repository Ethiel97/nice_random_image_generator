import 'package:flutter/material.dart';
import 'package:nice_image/core/utils/utils.dart';
import 'package:nice_image/l10n/l10n.dart';

/// Widget to display error states
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    required this.errorDetails,
    required this.onRetry,
    super.key,
  });

  final ErrorDetails errorDetails;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              errorDetails.icon,
              size: 64,
              color: Theme.of(context).colorScheme.error,
              semanticLabel: 'Error icon',
            ),
            const SizedBox(height: 16),
            Text(
              errorDetails.getTitle(l10n),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorDetails.displayMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(
                l10n.tryAgain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
