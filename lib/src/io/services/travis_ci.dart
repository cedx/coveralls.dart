import '../../io.dart';

/// Gets the [Travis CI](https://travis-ci.com) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) {
  final configuration = Configuration({
    'commit_sha': environment['TRAVIS_COMMIT'],
    'flag_name': environment['TRAVIS_JOB_NAME'],
    'service_branch': environment['TRAVIS_BRANCH'],
    'service_build_url': environment['TRAVIS_BUILD_WEB_URL'],
    'service_job_id': environment['TRAVIS_JOB_ID'],
    'service_name': 'travis-ci'
  });

  if (environment.containsKey('TRAVIS_PULL_REQUEST') && environment['TRAVIS_PULL_REQUEST'] != 'false')
    configuration['service_pull_request'] = environment['TRAVIS_PULL_REQUEST'];

  return configuration;
}
