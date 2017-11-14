import 'package:coveralls/coveralls.dart';

/// Gets the configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) => new Configuration({
  'commit_sha': env['SURF_SHA1'],
  'service_branch': env['SURF_REF'],
  'service_name': 'surf'
});
