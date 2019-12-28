import '../../io.dart';

/// Gets the [GitLab CI](https://gitlab.com) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) => Configuration({
  'commit_sha': environment['CI_BUILD_REF'],
  'service_branch': environment['CI_BUILD_REF_NAME'],
  'service_job_id': environment['CI_BUILD_ID'],
  'service_job_number': environment['CI_BUILD_NAME'],
  'service_name': 'gitlab-ci'
});
