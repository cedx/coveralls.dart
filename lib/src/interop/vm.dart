import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:http/http.dart' as http;
import 'package:platform/platform.dart';

/// A reference to the file system.
const FileSystem fileSystem = const LocalFileSystem();

/// A reference to the HTTP client.
final http.Client httpClient = new http.Client();

/// A reference to the platform.
const Platform platform = const LocalPlatform();
