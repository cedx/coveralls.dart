import 'package:coveralls/coveralls.dart';

/// Gets the [GitHub](https://github.com) configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) {
  final commitSha = env['GITHUB_SHA'];
  final gitRef = env['GITHUB_REF'] ?? '';
  final repository = env['GITHUB_REPOSITORY'];

  return Configuration({
    'commit_sha': commitSha,
    'service_branch': gitRef.startsWith('refs/heads/') ? gitRef.substring(11) : null,
    'service_build_url': commitSha != null && repository != null ? 'https://github.com/$repository/commit/$commitSha/checks' : null,
    'service_name': 'github'
  });
}
