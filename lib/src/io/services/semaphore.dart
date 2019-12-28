import '../../io.dart';

/// Gets the [Semaphore](https://semaphoreci.com) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) => Configuration({
  'commit_sha': environment['REVISION'],
  'service_branch': environment['BRANCH_NAME'],
  'service_name': 'semaphore',
  'service_number': environment['SEMAPHORE_BUILD_NUMBER'],
  'service_pull_request': environment['PULL_REQUEST_NUMBER']
});
