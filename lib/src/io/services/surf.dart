import '../../io.dart';

/// Gets the [Surf](https://github.com/surf-build/surf) configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) => Configuration({
  'commit_sha': env['SURF_SHA1'],
  'service_branch': env['SURF_REF'],
  'service_name': 'surf'
});
