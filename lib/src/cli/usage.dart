part of '../cli.dart';

/// The usage information.
final String usage = (StringBuffer()
  ..writeln('Send a coverage report to the Coveralls service.')..writeln()
  ..writeln('Usage: coveralls [options] <file>')..writeln()
  ..writeln('Options:')
  ..write(argParser.usage))
  .toString();
