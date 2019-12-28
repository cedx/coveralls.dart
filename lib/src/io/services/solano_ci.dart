import '../../io.dart';

/// Gets the [Solano CI](https://ci.solanolabs.com) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) {
  final serviceNumber = environment['TDDIUM_SESSION_ID'];
  return Configuration({
    'service_branch': environment['TDDIUM_CURRENT_BRANCH'],
    'service_build_url': serviceNumber != null ? 'https://ci.solanolabs.com/reports/$serviceNumber' : null,
    'service_job_number': environment['TDDIUM_TID'],
    'service_name': 'tddium',
    'service_number': serviceNumber,
    'service_pull_request': environment['TDDIUM_PR_ID']
  });
}
