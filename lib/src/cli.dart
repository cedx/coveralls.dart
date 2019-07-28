/// Provides the command line interface.
library coveralls.cli;

import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'cli.g.dart';
part 'cli/options.dart';
part 'cli/usage.dart';

/// The command line argument parser.
ArgParser get argParser => _$parserForOptions;
