import 'package:coveralls/coveralls.dart';

/// Gets the configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) => new Configuration({
  'commit_sha': env['WERCKER_GIT_COMMIT'],
  'service_branch': env['WERCKER_GIT_BRANCH'],
  'service_job_id': env['WERCKER_BUILD_ID'],
  'service_name': 'wercker'
});
