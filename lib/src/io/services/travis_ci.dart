import 'package:coveralls/coveralls.dart';

/// Gets the [Travis CI](https://travis-ci.com) configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) {
  final config = Configuration({
    'commit_sha': 'HEAD',
    'service_branch': env['TRAVIS_BRANCH'],
    'service_job_id': env['TRAVIS_JOB_ID'],
    'service_name': 'travis-ci'
  });

  if (env.containsKey('TRAVIS_PULL_REQUEST') && env['TRAVIS_PULL_REQUEST'] != 'false')
    config['service_pull_request'] = env['TRAVIS_PULL_REQUEST'];

  return config;
}
