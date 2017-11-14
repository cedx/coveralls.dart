import 'package:coveralls/coveralls.dart';

/// Gets the configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) => new Configuration({
  'commit_sha': env['REVISION'],
  'service_branch': env['BRANCH_NAME'],
  'service_name': 'semaphore',
  'service_number': env['SEMAPHORE_BUILD_NUMBER'],
  'service_pull_request': env['PULL_REQUEST_NUMBER']
});
