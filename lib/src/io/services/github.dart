import '../../io.dart';

/// Gets the [GitHub](https://github.com) configuration parameters from the specified [environment].
Configuration getConfiguration(Map<String, String> environment) {
  final commitSha = environment['GITHUB_SHA'];
  final repository = environment['GITHUB_REPOSITORY'];

  final gitRef = environment['GITHUB_REF'] ?? '';
  final gitRegex = RegExp(r'^refs/\w+/');

  return Configuration({
    'commit_sha': commitSha,
    'service_branch': gitRegex.hasMatch(gitRef) ? gitRef.replaceFirst(gitRegex, '') : null,
    'service_build_url': commitSha != null && repository != null ? 'https://github.com/$repository/commit/$commitSha/checks' : null,
    'service_name': 'github'
  });
}
