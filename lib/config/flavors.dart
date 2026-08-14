enum Flavor { dev, prod }

/// Holds the active [Flavor] and any flavor-specific values.
///
/// Only `dev` is wired to a real entrypoint today; `prod` is scaffolding
/// for when a separate release configuration is needed.
class FlavorConfig {
  FlavorConfig._({required this.flavor, required this.appName});

  factory FlavorConfig.init({
    required Flavor flavor,
    required String appName,
  }) {
    final config = FlavorConfig._(flavor: flavor, appName: appName);
    _instance = config;
    return config;
  }

  static FlavorConfig? _instance;

  final Flavor flavor;
  final String appName;

  static FlavorConfig get instance {
    final instance = _instance;
    if (instance == null) {
      throw StateError(
        'FlavorConfig not initialized. Call FlavorConfig.init first.',
      );
    }
    return instance;
  }

  static bool get isDev => instance.flavor == Flavor.dev;
  static bool get isProd => instance.flavor == Flavor.prod;
}
