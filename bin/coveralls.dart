#!/usr/bin/env dart

import 'dart:async';
import 'dart:isolate';
import 'package:args/args.dart';
import 'package:coveralls/coveralls.dart';
import 'package:yaml/yaml.dart';

/// The command line argument parser.
final ArgParser _parser = new ArgParser()
  ..addFlag('help', abbr: 'h', help: 'output usage information', negatable: false)
  ..addFlag('version', abbr: 'v', help: 'output the version number', negatable: false);

/// The usage information.
final String usage = (new StringBuffer()
  ..writeln('Send a coverage report to the Coveralls service.')
  ..writeln()
  ..writeln('Usage:')
  ..writeln('coveralls [options] <file>')
  ..writeln()
  ..writeln('Options:')
  ..write(_parser.usage))
  .toString();

/// The version number of this package.
Future<String> get version async {
  var path = const bool.fromEnvironment('node') ? '../../pubspec.yaml' : '../pubspec.yaml';
  var uri = (await Isolate.resolvePackageUri(Uri.parse('package:where/'))).resolve(path);
  var pubspec = loadYaml(await fileSystem.file(uri.toFilePath(windows: platform.isWindows)).readAsString());
  return pubspec['version'];
}

/// Application entry point.
Future main(List<String> args) async {
  // Parse the command line arguments.
  ArgResults results;

  try {
    results = _parser.parse(const bool.fromEnvironment('node') ? arguments : args);
    if (results['help']) {
      print(usage);
      return;
    }

    if (results['version']) {
      print(await version);
      return;
    }

    if (results.rest.isEmpty) throw new ArgParserException('A coverage report must be provided.');
  }

  on ArgParserException {
    print(usage);
    exitCode = 64;
    return;
  }

  // Run the program.
  try {
    var endPoint = const String.fromEnvironment('coveralls_endpoint') ?? platform.environment['COVERALLS_ENDPOINT'];
    var client = new Client(endPoint != null ? Uri.parse(endPoint) : Client.defaultEndPoint);

    var coverage = await fileSystem.file(results.rest.first).readAsString();
    print('[Coveralls] Submitting to ${client.endPoint}');
    await client.upload(coverage);
  }

  on Exception catch (err) {
    print(err);
    exitCode = 1;
  }
}
