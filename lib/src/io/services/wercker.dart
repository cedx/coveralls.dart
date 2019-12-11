import '../../io.dart';

/// Gets the [Wercker](https://app.wercker.com) configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) => Configuration({
  'commit_sha': env['WERCKER_GIT_COMMIT'],
  'service_branch': env['WERCKER_GIT_BRANCH'],
  'service_job_id': env['WERCKER_BUILD_ID'],
  'service_name': 'wercker'
});
