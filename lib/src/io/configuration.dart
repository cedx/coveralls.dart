part of '../io.dart';

/// Provides access to the coverage settings.
class Configuration extends Object with MapMixin<String, String> { // ignore: prefer_mixin

  /// Creates a new configuration from the specified [map].
  Configuration([Map<String, String> map]): _params = map ?? <String, String>{};

  /// Creates a new configuration from the specified YAML [document].
  /// Throws a [FormatException] if the specified document is invalid.
  Configuration.fromYaml(String document): _params = <String, String>{} {
    if (document == null || document.trim().isEmpty) throw const FormatException('The specified YAML document is empty.');

    try {
      final map = loadYaml(document);
      if (map is! Map) throw FormatException('The specified YAML document is invalid.', document);
      addAll(Map<String, String>.from(map));
    }

    on YamlException {
      throw FormatException('The specified YAML document is invalid.', document);
    }
  }

  /// The coverage parameters.
  final Map<String, String> _params;

  /// Creates a new configuration from the variables of the specified environment.
  /// If [environment] is not provided, it defaults to `Platform.environment`.
  static Future<Configuration> fromEnvironment([Map<String, String> environment]) async {
    environment ??= Platform.environment;
    final configuration = Configuration();

    // Standard.
    final serviceName = environment['CI_NAME'] ?? '';
    if (serviceName.isNotEmpty) configuration['service_name'] = serviceName;

    if (environment.containsKey('CI_BRANCH')) configuration['service_branch'] = environment['CI_BRANCH'];
    if (environment.containsKey('CI_BUILD_NUMBER')) configuration['service_number'] = environment['CI_BUILD_NUMBER'];
    if (environment.containsKey('CI_BUILD_URL')) configuration['service_build_url'] = environment['CI_BUILD_URL'];
    if (environment.containsKey('CI_COMMIT')) configuration['commit_sha'] = environment['CI_COMMIT'];
    if (environment.containsKey('CI_JOB_ID')) configuration['service_job_id'] = environment['CI_JOB_ID'];

    if (environment.containsKey('CI_PULL_REQUEST')) {
      final matches = RegExp(r'(\d+)$').allMatches(environment['CI_PULL_REQUEST']);
      if (matches.isNotEmpty && matches.first.groupCount >= 1) configuration['service_pull_request'] = matches.first[1];
    }

    // Coveralls.
    if (environment.containsKey('COVERALLS_REPO_TOKEN') || environment.containsKey('COVERALLS_TOKEN'))
      configuration['repo_token'] = environment['COVERALLS_REPO_TOKEN'] ?? environment['COVERALLS_TOKEN'];

    if (environment.containsKey('COVERALLS_COMMIT_SHA')) configuration['commit_sha'] = environment['COVERALLS_COMMIT_SHA'];
    if (environment.containsKey('COVERALLS_FLAG_NAME')) configuration['flag_name'] = environment['COVERALLS_FLAG_NAME'];
    if (environment.containsKey('COVERALLS_PARALLEL')) configuration['parallel'] = environment['COVERALLS_PARALLEL'];
    if (environment.containsKey('COVERALLS_RUN_AT')) configuration['run_at'] = environment['COVERALLS_RUN_AT'];
    if (environment.containsKey('COVERALLS_SERVICE_BRANCH')) configuration['service_branch'] = environment['COVERALLS_SERVICE_BRANCH'];
    if (environment.containsKey('COVERALLS_SERVICE_JOB_ID')) configuration['service_job_id'] = environment['COVERALLS_SERVICE_JOB_ID'];
    if (environment.containsKey('COVERALLS_SERVICE_NAME')) configuration['service_name'] = environment['COVERALLS_SERVICE_NAME'];

    // Git.
    if (environment.containsKey('GIT_AUTHOR_EMAIL')) configuration['git_author_email'] = environment['GIT_AUTHOR_EMAIL'];
    if (environment.containsKey('GIT_AUTHOR_NAME')) configuration['git_author_name'] = environment['GIT_AUTHOR_NAME'];
    if (environment.containsKey('GIT_BRANCH')) configuration['service_branch'] = environment['GIT_BRANCH'];
    if (environment.containsKey('GIT_COMMITTER_EMAIL')) configuration['git_committer_email'] = environment['GIT_COMMITTER_EMAIL'];
    if (environment.containsKey('GIT_COMMITTER_NAME')) configuration['git_committer_name'] = environment['GIT_COMMITTER_NAME'];
    if (environment.containsKey('GIT_ID')) configuration['commit_sha'] = environment['GIT_ID'];
    if (environment.containsKey('GIT_MESSAGE')) configuration['git_message'] = environment['GIT_MESSAGE'];

    // CI services.
    if (environment.containsKey('TRAVIS')) {
      await travis_ci.loadLibrary();
      configuration.merge(travis_ci.getConfiguration(environment));
      if (serviceName.isNotEmpty && serviceName != 'travis-ci') configuration['service_name'] = serviceName;
    }
    else if (environment.containsKey('APPVEYOR')) {
      await appveyor.loadLibrary();
      configuration.merge(appveyor.getConfiguration(environment));
    }
    else if (environment.containsKey('CIRCLECI')) {
      await circleci.loadLibrary();
      configuration.merge(circleci.getConfiguration(environment));
    }
    else if (serviceName == 'codeship') {
      await codeship.loadLibrary();
      configuration.merge(codeship.getConfiguration(environment));
    }
    else if (environment.containsKey('GITHUB_WORKFLOW')) {
      await github.loadLibrary();
      configuration.merge(github.getConfiguration(environment));
    }
    else if (environment.containsKey('GITLAB_CI')) {
      await gitlab_ci.loadLibrary();
      configuration.merge(gitlab_ci.getConfiguration(environment));
    }
    else if (environment.containsKey('JENKINS_URL')) {
      await jenkins.loadLibrary();
      configuration.merge(jenkins.getConfiguration(environment));
    }
    else if (environment.containsKey('SEMAPHORE')) {
      await semaphore.loadLibrary();
      configuration.merge(semaphore.getConfiguration(environment));
    }
    else if (environment.containsKey('SURF_SHA1')) {
      await surf.loadLibrary();
      configuration.merge(surf.getConfiguration(environment));
    }
    else if (environment.containsKey('TDDIUM')) {
      await solano_ci.loadLibrary();
      configuration.merge(solano_ci.getConfiguration(environment));
    }
    else if (environment.containsKey('WERCKER')) {
      await wercker.loadLibrary();
      configuration.merge(wercker.getConfiguration(environment));
    }

    return configuration;
  }

  /// Loads the default configuration.
  /// The default values are read from the environment variables and an optional `.coveralls.yml` file.
  static Future<Configuration> loadDefaults([String coverallsFile = '.coveralls.yml']) async {
    final defaults = await Configuration.fromEnvironment();

    try {
      defaults.merge(Configuration.fromYaml(await File(coverallsFile).readAsString()));
      return defaults;
    }

    on Exception {
      return defaults;
    }
  }

  /// The keys of this configuration.
  @override
  Iterable<String> get keys => _params.keys;

  /// Returns the value for the given [key] or `null` if [key] is not in this configuration.
  @override
  String operator [](Object key) => _params[key];

  /// Associates the [key] with the given [value].
  @override
  void operator []=(String key, String value) => _params[key] = value;

  /// Removes all pairs from this configuration.
  @override
  void clear() => _params.clear();

  /// Adds all entries of the specified [configuration] to this one, ignoring `null` values.
  void merge(Configuration configuration) {
    for (final entry in configuration.entries)
      if (entry.value != null) this[entry.key] = entry.value;
  }

  /// Removes the specified [key] and its associated value from this configuration.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key) => _params.remove(key);
}
