#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:coveralls/coveralls.dart';

/// The version number of this package.
const String version = '6.0.0';

/// The command line argument parser.
final ArgParser _parser = new ArgParser()
  ..addFlag('help', abbr: 'h', help: 'output usage information', negatable: false)
  ..addFlag('version', abbr: 'v', help: 'output the version number', negatable: false);

/// The usage information.
final String usage = (new StringBuffer()
  ..writeln('Send a coverage report to the Coveralls service.')
  ..writeln()
  ..writeln('Usage:')
  ..writeln('pub global run coveralls [options] <file>')
  ..writeln()
  ..writeln('Options:')
  ..write(_parser.usage))
  .toString();

/// Application entry point.
Future main(List<String> args) async {
  // Parse the command line arguments.
  ArgResults results;

  try {
    results = _parser.parse(args);
    if (results['help']) {
      print(usage);
      exit(0);
    }

    if (results['version']) {
      print(version);
      exit(0);
    }

    if (results.rest.isEmpty) throw new ArgParserException('A coverage report must be provided.');
  }

  on ArgParserException {
    print(usage);
    exit(64);
  }

  // Run the program.
  try {
    var endPoint = const String.fromEnvironment('coveralls_endpoint') ?? Platform.environment['COVERALLS_ENDPOINT'];
    var client = new Client(endPoint != null ? Uri.parse(endPoint) : Client.defaultEndPoint);

    var coverage = await new File(results.rest.first).readAsString();
    print('[Coveralls] Submitting to ${client.endPoint}');
    return client.upload(coverage);
  }

  on Exception catch (err) {
    print(err);
    exit(1);
  }
}
