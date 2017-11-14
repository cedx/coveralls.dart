import 'package:file/file.dart';
import 'package:http/http.dart' as http;
import 'package:nodejs_interop/nodejs_interop.dart';
import 'package:platform/platform.dart';

/// A reference to the file system.
const FileSystem fileSystem = null; // TODO: const NodejsFileSystem();

/// A reference to the HTTP client.
final http.Client httpClient = null; // TODO: new NodejsHttpClient();

/// A reference to the platform.
const Platform platform = const NodejsPlatform();
