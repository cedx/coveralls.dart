import 'package:coveralls/coveralls.dart';

/// Gets the configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) {
  var serviceNumber = env['TDDIUM_SESSION_ID'];
  return new Configuration({
    'service_branch': env['TDDIUM_CURRENT_BRANCH'],
    'service_build_url': serviceNumber != null ? 'https://ci.solanolabs.com/reports/$serviceNumber' : null,
    'service_job_number': env['TDDIUM_TID'],
    'service_name': 'tddium',
    'service_number': serviceNumber,
    'service_pull_request': env['TDDIUM_PR_ID']
  });
}
