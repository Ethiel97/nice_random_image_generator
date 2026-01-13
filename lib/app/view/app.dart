import 'package:flutter/material.dart';
import 'package:nice_image/features/random_image/random_image.dart';
import 'package:nice_image/l10n/l10n.dart';
import 'package:nice_image/shared/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nice Image',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const RandomImagePage(),
    );
  }
}
