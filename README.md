# Nice Random Image generator

![Demo](demo.gif)


A beautiful random image generator Flutter app that displays random images with adaptive background colors.

## Features

- **Random Image Display**: Fetches and displays random images from a remote API
- **Adaptive Background**: Automatically extracts and applies dominant colors from images
- **Light/Dark Mode**: Supports both light and dark themes with appropriate color adaptations
- **Smooth Animations**: Polished transitions for image loading and background color changes
- **Responsive Design**: Adapts to different screen sizes with square image display
- **Accessibility**: Includes semantic labels and proper contrast ratios
- **Loading & Error States**: Comprehensive state management with user-friendly feedback

## Architecture

This project follows **Feature-first Clean Architecture** principles:

```
lib/
├── app/                    # App configuration and entry point
├── bootstrap.dart          # DI initialization and app setup
├── core/
│   ├── di/                 # Dependency injection (get_it + injectable)
│   ├── errors/             # Error handling (AppException + ErrorDetails)
│   ├── network/            # HTTP client abstraction + Dio implementation
│   ├── services/           # Cross-cutting services (ImagePaletteService)
│   └── utils/              # Utilities (ValueWrapper, extensions)
├── features/
│   └── random_image/
│       ├── data/           # Data sources, models, repositories
│       ├── domain/         # Entities, repository contracts
│       └── presentation/   # Cubit, pages, widgets
└── shared/
    └── theme/              # App theming configuration
```

### Tech Stack

- **Framework**: Flutter 3.35.0+
- **State Management**: flutter_bloc + Cubit
- **Dependency Injection**: get_it + injectable
- **Networking**: Dio
- **Image Caching**: cached_network_image
- **Color Extraction**: palette_generator
- **Testing**: flutter_test, bloc_test, mocktail

---

## Getting Started 🚀

### Prerequisites

- Flutter SDK ≥3.35.0
- Dart SDK ≥3.9.0

### Installation

1. Clone the repository:

```sh
git clone https://github.com/ethiel97/nice_random_image.git
cd nice_image
```

2. Install dependencies:

```sh
flutter pub get
```

3. Generate dependency injection code:

```sh
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:

```sh
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

_\*Nice Image works on iOS, Android._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project uses Flutter's built-in localization support with ARB files for managing translations.

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:nice_image/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

<key>CFBundleLocalizations</key>
<array>
<string>en</string>
<string>es</string>
</array>

        ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.
