import '../../io.dart';

/// Gets the [CircleCI](https://circleci.com) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) => Configuration({
  'commit_sha': environment['CIRCLE_SHA1'],
  'parallel': int.tryParse(environment['CIRCLE_NODE_TOTAL'] ?? '0', radix: 10) ?? 0 > 1 ? 'true' : 'false',
  'service_branch': environment['CIRCLE_BRANCH'],
  'service_build_url': environment['CIRCLE_BUILD_URL'],
  'service_job_number': environment['CIRCLE_NODE_INDEX'],
  'service_name': 'circleci',
  'service_number': environment['CIRCLE_BUILD_NUM']
});
