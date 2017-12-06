# Coveralls for Dart
![Runtime](https://img.shields.io/badge/dart-%3E%3D1.24-brightgreen.svg) ![Release](https://img.shields.io/pub/v/coveralls.svg) ![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Coverage](https://coveralls.io/repos/github/cedx/coveralls.dart/badge.svg) ![Build](https://travis-ci.org/cedx/coveralls.dart.svg)

Send [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) and [Clover](https://www.atlassian.com/software/clover) coverage reports to the [Coveralls](https://coveralls.io) service, in [Dart](https://www.dartlang.org).

## Requirements
The latest [Dart SDK](https://www.dartlang.org) and [Pub](https://pub.dartlang.org) versions.
If you plan to play with the sources, you will also need the latest [Grinder](http://google.github.io/grinder.dart) version.

## Usage

### Command line interface
The easy way. From a command prompt, install the `coveralls` executable:

```shell
$ pub global activate coveralls
```

> Consider adding the [`pub global`](https://www.dartlang.org/tools/pub/cmd/pub-global) executables directory to your system path.

Then use it to upload your coverage reports:

```shell
$ coveralls --help

Send a coverage report to the Coveralls service.

Usage:
coveralls [options] <file>

Options:
-h, --help           output usage information
-v, --version        output the version number
```

For example:

```shell
$ coveralls build/lcov.info
```

### Programming interface
The hard way. Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  coveralls: *
```

Then, from a command prompt, install the library:

```shell
$ pub get
```

Now in your [Dart](https://www.dartlang.org) code, you can use the `Client` class to upload your coverage reports:

```dart
import 'dart:async';
import 'dart:io';
import 'package:coveralls/coveralls.dart';

Future main() async {
  try {
    var coverage = await new File('/path/to/coverage.report').readAsString();
    await new Client().upload(coverage);
    print('The report was sent successfully.');
  }
  
  on Exception catch (err) {
    print('An error occurred: $err');
  }
}
```

### Node.js support
This package supports the [Node.js](https://nodejs.org) platform.
A JavaScript executable can be generated using the following [Grinder](http://google.github.io/grinder.dart) command:

```shell
$ grind
```

This command will build a `coveralls.js` file in the `bin` folder of this package.
The generated executable has the same features as the [Dart](https://www.dartlang.org) command line:

```shell
$ node bin/coveralls.js --help
$ node bin/coveralls.js build/lcov.info
```

## Supported coverage formats
Currently, this package supports two formats of coverage reports:
- [LCOV](http://ltp.sourceforge.net/coverage/lcov.php): the de facto standard.
- [Clover](https://www.atlassian.com/software/clover): a common format produced by [Java](https://www.java.com) and [PHP](https://secure.php.net) test frameworks.

## Supported CI services
This project has been tested with [Travis CI](https://travis-ci.com) service, but these services should also work with no extra effort:
- [AppVeyor](https://www.appveyor.com)
- [CircleCI](https://circleci.com)
- [Codeship](https://codeship.com)
- [GitLab CI](https://gitlab.com)
- [Jenkins](https://jenkins.io)
- [Semaphore](https://semaphoreci.com)
- [Solano CI](https://ci.solanolabs.com)
- [Surf](https://github.com/surf-build/surf)
- [Wercker](http://www.wercker.com)

## Environment variables
If your build system is not supported, you can still use this package.
There are a few environment variables that are necessary for supporting your build system:
- `COVERALLS_SERVICE_NAME` : the name of your build system.
- `COVERALLS_REPO_TOKEN` : the secret repository token from [Coveralls](https://coveralls.io).

There are optional environment variables:
- `COVERALLS_SERVICE_JOB_ID` : a string that uniquely identifies the build job.
- `COVERALLS_RUN_AT` : a date string for the time that the job ran. This defaults to your build system's date/time if you don't set it.

The full list of supported environment variables is available in the source code of the `Configuration` class (see the `fromEnvironment()` static method).

## The `.coveralls.yml` file
This package supports the same configuration sources as the [Coveralls](https://coveralls.io) ones:  
[Coveralls currently supports](https://coveralls.zendesk.com/hc/en-us/articles/201347419-Coveralls-currently-supports)

## See also
- [API reference](https://cedx.github.io/coveralls.dart)
- [Code coverage](https://coveralls.io/github/cedx/coveralls.dart)
- [Continuous integration](https://travis-ci.org/cedx/coveralls.dart)

## License
[Coveralls for Dart](https://github.com/cedx/coveralls.dart) is distributed under the MIT License.
