/// Provides the I/O support.
library coveralls.io;

import 'package:file/file.dart';
import 'package:http/http.dart' as http;
import 'package:platform/platform.dart';
import 'package:process/process.dart';

/// The command line arguments.
List<String> get arguments => const [];

/// The global exit code for the process.
int get exitCode => 0;
set exitCode(int value) => null;

/// A reference to the file system.
const FileSystem fileSystem = null;

/// A reference to the HTTP client.
final http.Client httpClient = null;

/// A reference to the platform.
const Platform platform = null;

/// A reference to the process manager.
const ProcessManager processManager = null;
