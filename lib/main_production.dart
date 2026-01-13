import 'package:nice_image/app/app.dart';
import 'package:nice_image/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
