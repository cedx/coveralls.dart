import 'package:coveralls/coveralls.dart';

/// Gets the configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) => new Configuration({
  'commit_sha': env['GIT_COMMIT'],
  'service_branch': env['GIT_BRANCH'],
  'service_build_url': env['BUILD_URL'],
  'service_job_id': env['BUILD_ID'],
  'service_name': 'jenkins',
  'service_number': env['BUILD_NUMBER'],
  'service_pull_request': env['ghprbPullId']
});
