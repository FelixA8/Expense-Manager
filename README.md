## About Project
An application for managing expenses and income.

# First Run

The project is configured with mock data if you run the **MOCK** flavor. See the next section for configuring run configurations.

After installing the package dependencies with 

```
flutter pub get
```

run the code generation tool 

```
flutter pub run build_runner build
```

## Run Configurations

In addition to the [Flutter's build modes][flutter_build_modes] (debug, profile, release), 
the project has 4 flavours/schemas for defining environments:
- **mock** - mock environment that uses mock values. Launches `main_mock.dart`
- **dev** - development environment that targets a development server. Launches `main_dev.dart`
- **staging** - staging environment that targets a staging server. Launches `main_staging.dart`
- **production** - production environment that targets a production server. Launches `main_production.dart`

To run the app use the following command:
```
flutter run --flavor dev -t lib/main_dev.dart
```
or edit run configurations in Android Studio:
- Go to EditConfigurations...
- Enter configuration name: DEV, STAGE, PROD
- Enter dart entry point: main_dev.dart, main_staging.dart, main_production.dart
- Enter additional run args: --flavor=dev, --flavor=staging, --flavor=production
- Enter build flavor: dev, staging, production

See [flavor_config.dart] for environment specific config.

For adding an additional Flutter flavours see the [official documentation][flutter_flavours_official] 
and [this blog post][blog_flavouring_flutter]. 

[flutter_build_modes]: https://flutter.dev/docs/testing/build-modes
[flavor_config.dart]: ./lib/config/flavor_config.dart
[flutter_flavours_official]: https://flutter.dev/docs/deployment/flavors
[blog_flavouring_flutter]: https://medium.com/@salvatoregiordanoo/flavoring-flutter-392aaa875f36
