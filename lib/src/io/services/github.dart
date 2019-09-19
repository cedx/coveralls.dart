import 'package:coveralls/coveralls.dart';

/// Gets the [GitHub](https://github.com) configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) => Configuration({
  'commit_sha': env['GITHUB_SHA'],
  'service_branch': env['GITHUB_REF'],
  'service_name': 'github'
});
