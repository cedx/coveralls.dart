import '../../io.dart';

/// Gets the [Surf](https://github.com/surf-build/surf) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) => Configuration({
  'commit_sha': environment['SURF_SHA1'],
  'service_branch': environment['SURF_REF'],
  'service_name': 'surf'
});
