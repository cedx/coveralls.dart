// GENERATED CODE - DO NOT MODIFY BY HAND

part of coveralls.cli;

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) => Options(
    help: result['help'] as bool,
    rest: result.rest,
    version: result['version'] as bool);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addFlag('help',
      abbr: 'h', help: 'Output usage information.', negatable: false)
  ..addFlag('version',
      abbr: 'v', help: 'Output the version number.', negatable: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
