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
  /// If [env] is not provided, it defaults to `Platform.environment`.
  static Future<Configuration> fromEnvironment([Map<String, String> env]) async {
    env ??= Platform.environment;
    final config = Configuration();

    // Standard.
    final serviceName = env['CI_NAME'] ?? '';
    if (serviceName.isNotEmpty) config['service_name'] = serviceName;

    if (env.containsKey('CI_BRANCH')) config['service_branch'] = env['CI_BRANCH'];
    if (env.containsKey('CI_BUILD_NUMBER')) config['service_number'] = env['CI_BUILD_NUMBER'];
    if (env.containsKey('CI_BUILD_URL')) config['service_build_url'] = env['CI_BUILD_URL'];
    if (env.containsKey('CI_COMMIT')) config['commit_sha'] = env['CI_COMMIT'];
    if (env.containsKey('CI_JOB_ID')) config['service_job_id'] = env['CI_JOB_ID'];

    if (env.containsKey('CI_PULL_REQUEST')) {
      final matches = RegExp(r'(\d+)$').allMatches(env['CI_PULL_REQUEST']);
      if (matches.isNotEmpty && matches.first.groupCount >= 1) config['service_pull_request'] = matches.first[1];
    }

    // Coveralls.
    if (env.containsKey('COVERALLS_REPO_TOKEN') || env.containsKey('COVERALLS_TOKEN'))
      config['repo_token'] = env['COVERALLS_REPO_TOKEN'] ?? env['COVERALLS_TOKEN'];

    if (env.containsKey('COVERALLS_COMMIT_SHA')) config['commit_sha'] = env['COVERALLS_COMMIT_SHA'];
    if (env.containsKey('COVERALLS_PARALLEL')) config['parallel'] = env['COVERALLS_PARALLEL'];
    if (env.containsKey('COVERALLS_RUN_AT')) config['run_at'] = env['COVERALLS_RUN_AT'];
    if (env.containsKey('COVERALLS_SERVICE_BRANCH')) config['service_branch'] = env['COVERALLS_SERVICE_BRANCH'];
    if (env.containsKey('COVERALLS_SERVICE_JOB_ID')) config['service_job_id'] = env['COVERALLS_SERVICE_JOB_ID'];
    if (env.containsKey('COVERALLS_SERVICE_NAME')) config['service_name'] = env['COVERALLS_SERVICE_NAME'];

    // Git.
    if (env.containsKey('GIT_AUTHOR_EMAIL')) config['git_author_email'] = env['GIT_AUTHOR_EMAIL'];
    if (env.containsKey('GIT_AUTHOR_NAME')) config['git_author_name'] = env['GIT_AUTHOR_NAME'];
    if (env.containsKey('GIT_BRANCH')) config['service_branch'] = env['GIT_BRANCH'];
    if (env.containsKey('GIT_COMMITTER_EMAIL')) config['git_committer_email'] = env['GIT_COMMITTER_EMAIL'];
    if (env.containsKey('GIT_COMMITTER_NAME')) config['git_committer_name'] = env['GIT_COMMITTER_NAME'];
    if (env.containsKey('GIT_ID')) config['commit_sha'] = env['GIT_ID'];
    if (env.containsKey('GIT_MESSAGE')) config['git_message'] = env['GIT_MESSAGE'];

    // CI services.
    if (env.containsKey('TRAVIS')) {
      await travis_ci.loadLibrary();
      config.addAll(travis_ci.getConfiguration(env));
      if (serviceName.isNotEmpty && serviceName != 'travis-ci') config['service_name'] = serviceName;
    }
    else if (env.containsKey('APPVEYOR')) {
      await appveyor.loadLibrary();
      config.addAll(appveyor.getConfiguration(env));
    }
    else if (env.containsKey('CIRCLECI')) {
      await circleci.loadLibrary();
      config.addAll(circleci.getConfiguration(env));
    }
    else if (serviceName == 'codeship') {
      await codeship.loadLibrary();
      config.addAll(codeship.getConfiguration(env));
    }
    else if (env.containsKey('GITLAB_CI')) {
      await gitlab_ci.loadLibrary();
      config.addAll(gitlab_ci.getConfiguration(env));
    }
    else if (env.containsKey('JENKINS_URL')) {
      await jenkins.loadLibrary();
      config.addAll(jenkins.getConfiguration(env));
    }
    else if (env.containsKey('SEMAPHORE')) {
      await semaphore.loadLibrary();
      config.addAll(semaphore.getConfiguration(env));
    }
    else if (env.containsKey('SURF_SHA1')) {
      await surf.loadLibrary();
      config.addAll(surf.getConfiguration(env));
    }
    else if (env.containsKey('TDDIUM')) {
      await solano_ci.loadLibrary();
      config.addAll(solano_ci.getConfiguration(env));
    }
    else if (env.containsKey('WERCKER')) {
      await wercker.loadLibrary();
      config.addAll(wercker.getConfiguration(env));
    }

    return config;
  }

  /// Loads the default configuration.
  /// The default values are read from the environment variables and an optional `.coveralls.yml` file.
  static Future<Configuration> loadDefaults([String coverallsFile = '.coveralls.yml']) async {
    final defaults = await Configuration.fromEnvironment();

    try {
      defaults.addAll(Configuration.fromYaml(await File(coverallsFile).readAsString()));
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

  /// Removes the specified [key] and its associated value from this configuration.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key) => _params.remove(key);

  /// Converts this object to a [Map] in JSON format.
  Map<String, String> toJson() => _params;
}
