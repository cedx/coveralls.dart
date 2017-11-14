import 'package:coveralls/coveralls.dart';

/// Gets the configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) => new Configuration({
  'commit_sha': env['CIRCLE_SHA1'],
  'parallel': int.parse(env['CIRCLE_NODE_TOTAL'] ?? '0', radix: 10, onError: (_) => 0) > 1 ? 'true' : 'false',
  'service_branch': env['CIRCLE_BRANCH'],
  'service_build_url': env['CIRCLE_BUILD_URL'],
  'service_job_number': env['CIRCLE_NODE_INDEX'],
  'service_name': 'circleci',
  'service_number': env['CIRCLE_BUILD_NUM']
});
