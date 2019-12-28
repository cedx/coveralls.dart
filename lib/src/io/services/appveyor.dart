import '../../io.dart';

/// Gets the [AppVeyor](https://www.appveyor.com) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) {
  final repoName = environment['APPVEYOR_REPO_NAME'];
  final serviceNumber = environment['APPVEYOR_BUILD_VERSION'];

  return Configuration({
    'commit_sha': environment['APPVEYOR_REPO_COMMIT'],
    'git_author_email': environment['APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL'],
    'git_author_name': environment['APPVEYOR_REPO_COMMIT_AUTHOR'],
    'git_message': environment['APPVEYOR_REPO_COMMIT_MESSAGE'],
    'service_branch': environment['APPVEYOR_REPO_BRANCH'],
    'service_build_url': repoName != null && serviceNumber != null ? 'https://ci.appveyor.com/project/$repoName/build/$serviceNumber' : null,
    'service_job_id': environment['APPVEYOR_BUILD_ID'],
    'service_job_number': environment['APPVEYOR_BUILD_NUMBER'],
    'service_name': 'appveyor',
    'service_number': serviceNumber
  });
}
