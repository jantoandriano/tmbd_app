import 'package:cinetrack/bootstrap.dart';
import 'package:cinetrack/config/flavors.dart';

Future<void> main() async {
  await bootstrap(flavor: Flavor.dev);
}
