import 'package:coveralls/coveralls.dart';

/// Gets the [Solano CI](https://ci.solanolabs.com) configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) {
  final serviceNumber = env['TDDIUM_SESSION_ID'];
  return Configuration({
    'service_branch': env['TDDIUM_CURRENT_BRANCH'],
    'service_build_url': serviceNumber != null ? 'https://ci.solanolabs.com/reports/$serviceNumber' : null,
    'service_job_number': env['TDDIUM_TID'],
    'service_name': 'tddium',
    'service_number': serviceNumber,
    'service_pull_request': env['TDDIUM_PR_ID']
  });
}
