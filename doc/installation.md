# Installation

## Requirements
Before installing **Coveralls for Dart**, you need to make sure you have the [Dart SDK](https://dart.dev/tools/sdk)
and [Pub](https://dart.dev/tools/pub/cmd), the Dart package manager, up and running.

!!! warning
    Coveralls for Dart requires Dart >= **2.3.0**.

You can verify if you're already good to go with the following commands:

```shell
dart --version
# Dart VM version: 2.3.0 (Unknown timestamp) on "linux_x64"

pub --version
# Pub 2.3.0
```

!!! info
    If you plan to play with the package sources, you will also need
    [Grinder](https://google.github.io/grinder.dart) and [Material for MkDocs](https://squidfunk.github.io/mkdocs-material).

## Installing with Pub package manager

### 1. Depend on it
Add this to your project's `pubspec.yaml` file:

```yaml
dependencies:
  coveralls: *
```

### 2. Install it
Install this package and its dependencies from a command prompt:

```shell
pub get
```

### 3. Import it
Now in your [Dart](https://dart.dev) code, you can use:

```dart
import 'package:coveralls/coveralls.dart';
```
