# Changelog
This file contains highlights of what changes on each version of the [Coveralls for Dart](https://github.com/cedx/coveralls.dart) package.

## Version [3.0.0](https://github.com/cedx/coveralls.dart/compare/v2.1.0...v3.0.0)
- Added support for [Node.js](https://nodejs.org) platform.
- Added the `fileSystem`, `platform` and `processManager` constants.
- Added the `arguments` and `exitCode` properties.

## Version [2.1.0](https://github.com/cedx/coveralls.dart/compare/v2.0.1...v2.1.0)
- Updated the package dependencies.

## Version [2.0.1](https://github.com/cedx/coveralls.dart/compare/v2.0.0...v2.0.1)
- Fixed a bug: the CLI script doesn't run when using the `pub global run` command.

## Version [2.0.0](https://github.com/cedx/coveralls.dart/compare/v1.0.0...v2.0.0)
- Breaking change: changed the signature of most class constructors.
- Breaking change: most class properties are now `final`.
- Breaking change: raised the required [Dart](https://www.dartlang.org) version.
- Breaking change: replaced the `-f|--file` named argument of the CLI script by an anonymous argument (e.g. `coveralls lcov.info` instead of `coveralls -f lcov.info`)
- Breaking change: the `version` property is now private.
- Added support for [Clover](https://www.atlassian.com/software/clover) reports.
- Changed licensing for the [MIT License](https://opensource.org/licenses/MIT).
- Replaced the [`which`](https://pub.dartlang.org/packages/which) module by [`where`](https://pub.dartlang.org/packages/where).
- Updated the package dependencies.

## Version [1.0.0](https://github.com/cedx/coveralls.dart/compare/v0.3.0...v1.0.0)
- First stable release.

## Version [0.3.0](https://github.com/cedx/coveralls.dart/compare/v0.2.0...v0.3.0)
- Updated the package dependencies.

## Version [0.2.0](https://github.com/cedx/coveralls.dart/compare/v0.1.1...v0.2.0)
- Updated the package dependencies.

## Version [0.1.1](https://github.com/cedx/coveralls.dart/compare/v0.1.0...v0.1.1)
- Updated the documentation.

## Version 0.1.0
- Initial release.
