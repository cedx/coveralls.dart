import '../../io.dart';

/// Gets the [Wercker](https://app.wercker.com) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) => Configuration({
  'commit_sha': environment['WERCKER_GIT_COMMIT'],
  'service_branch': environment['WERCKER_GIT_BRANCH'],
  'service_job_id': environment['WERCKER_BUILD_ID'],
  'service_name': 'wercker'
});
