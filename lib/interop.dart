/// Provides interoperability with native APIs.
library coveralls.interop;

import 'package:file/file.dart';
import 'package:http/http.dart' as http;
import 'package:platform/platform.dart';

/// A reference to the file system.
const FileSystem fileSystem = null;

/// A reference to the HTTP client.
final http.Client httpClient = null;

/// A reference to the platform.
const Platform platform = null;
