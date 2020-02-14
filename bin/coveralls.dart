#!/usr/bin/env dart

// ignore_for_file: avoid_print
import 'dart:io';
import 'package:coveralls/coveralls.dart';
import 'package:coveralls/src/cli.dart';
import 'package:coveralls/src/version.dart';

/// Application entry point.
Future<void> main(List<String> args) async {
  // Parse the command line arguments.
  Options options;

  try {
    options = parseOptions(args);
    if (options.help) return print(usage);
    if (options.version) return print(packageVersion);
    if (options.rest.isEmpty) throw const FormatException('A coverage report must be provided.');
  }

  on FormatException {
    print(usage);
    exitCode = 64;
    return;
  }

  // Run the program.
  try {
    final endPoint = Platform.environment['COVERALLS_ENDPOINT'];
    final client = Client(endPoint != null ? Uri.parse(endPoint) : Client.defaultEndPoint);

    final coverage = await File(options.rest.first).readAsString();
    print('[Coveralls] Submitting to ${client.endPoint}');
    await client.upload(coverage);
  }

  on Exception catch (err) {
    print(err);
    exitCode = 1;
  }
}
