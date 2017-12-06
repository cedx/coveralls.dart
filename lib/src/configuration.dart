part of coveralls;

/// Provides access to the coverage settings.
class Configuration extends MapBase<String, String> {

  /// The coverage parameters.
  final Map<String, String> _params;

  /// Creates a new configuration from the specified [map].
  Configuration([Map<String, String> map]): _params = new Map.from(map ?? const {});

  /// Creates a new configuration from the variables of the specified environment.
  /// If [env] is not provided, it defaults to `platform.environment`.
  Configuration.fromEnvironment([Map<String, String> env]): _params = {} {
    env ??= platform.environment;

    // Standard.
    var serviceName = env['CI_NAME'] ?? '';
    if (serviceName.isNotEmpty) this['service_name'] = serviceName;

    if (env.containsKey('CI_BRANCH')) this['service_branch'] = env['CI_BRANCH'];
    if (env.containsKey('CI_BUILD_NUMBER')) this['service_number'] = env['CI_BUILD_NUMBER'];
    if (env.containsKey('CI_BUILD_URL')) this['service_build_url'] = env['CI_BUILD_URL'];
    if (env.containsKey('CI_COMMIT')) this['commit_sha'] = env['CI_COMMIT'];
    if (env.containsKey('CI_JOB_ID')) this['service_job_id'] = env['CI_JOB_ID'];

    if (env.containsKey('CI_PULL_REQUEST')) {
      var matches = new RegExp(r'(\d+)$').allMatches(env['CI_PULL_REQUEST']);
      if (matches.isNotEmpty && matches.first.groupCount >= 1) this['service_pull_request'] = matches.first[1];
    }

    // Coveralls.
    if (env.containsKey('COVERALLS_REPO_TOKEN') || env.containsKey('COVERALLS_TOKEN'))
      this['repo_token'] = env['COVERALLS_REPO_TOKEN'] ?? env['COVERALLS_TOKEN'];

    if (env.containsKey('COVERALLS_COMMIT_SHA')) this['commit_sha'] = env['COVERALLS_COMMIT_SHA'];
    if (env.containsKey('COVERALLS_PARALLEL')) this['parallel'] = env['COVERALLS_PARALLEL'];
    if (env.containsKey('COVERALLS_RUN_AT')) this['run_at'] = env['COVERALLS_RUN_AT'];
    if (env.containsKey('COVERALLS_SERVICE_BRANCH')) this['service_branch'] = env['COVERALLS_SERVICE_BRANCH'];
    if (env.containsKey('COVERALLS_SERVICE_JOB_ID')) this['service_job_id'] = env['COVERALLS_SERVICE_JOB_ID'];
    if (env.containsKey('COVERALLS_SERVICE_NAME')) this['service_name'] = env['COVERALLS_SERVICE_NAME'];

    // Git.
    if (env.containsKey('GIT_AUTHOR_EMAIL')) this['git_author_email'] = env['GIT_AUTHOR_EMAIL'];
    if (env.containsKey('GIT_AUTHOR_NAME')) this['git_author_name'] = env['GIT_AUTHOR_NAME'];
    if (env.containsKey('GIT_BRANCH')) this['service_branch'] = env['GIT_BRANCH'];
    if (env.containsKey('GIT_COMMITTER_EMAIL')) this['git_committer_email'] = env['GIT_COMMITTER_EMAIL'];
    if (env.containsKey('GIT_COMMITTER_NAME')) this['git_committer_name'] = env['GIT_COMMITTER_NAME'];
    if (env.containsKey('GIT_ID')) this['commit_sha'] = env['GIT_ID'];
    if (env.containsKey('GIT_MESSAGE')) this['git_message'] = env['GIT_MESSAGE'];

    // CI services.
    if (env.containsKey('TRAVIS')) {
      addAll(travis_ci.getConfiguration(env));
      if (serviceName.isNotEmpty && serviceName != 'travis-ci') this['service_name'] = serviceName;
    }
    else if (env.containsKey('APPVEYOR')) addAll(appveyor.getConfiguration(env));
    else if (env.containsKey('CIRCLECI')) addAll(circleci.getConfiguration(env));
    else if (serviceName == 'codeship') addAll(codeship.getConfiguration(env));
    else if (env.containsKey('GITLAB_CI')) addAll(gitlab_ci.getConfiguration(env));
    else if (env.containsKey('JENKINS_URL')) addAll(jenkins.getConfiguration(env));
    else if (env.containsKey('SEMAPHORE')) addAll(semaphore.getConfiguration(env));
    else if (env.containsKey('SURF_SHA1')) addAll(surf.getConfiguration(env));
    else if (env.containsKey('TDDIUM')) addAll(solano_ci.getConfiguration(env));
    else if (env.containsKey('WERCKER')) addAll(wercker.getConfiguration(env));
  }

  /// Creates a new configuration from the specified YAML [document].
  /// Throws a [FormatException] if the specified document is invalid.
  Configuration.fromYaml(String document): _params = {} {
    if (document == null || document.trim().isEmpty) throw const FormatException('The specified YAML document is empty.');

    try {
      var map = loadYaml(document);
      if (map is! Map<String, String>) throw new FormatException('The specified YAML document is invalid.', document);
      addAll(map);
    }

    on YamlException {
      throw new FormatException('The specified YAML document is invalid.', document);
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

  /// Loads the default configuration.
  /// The default values are read from the environment variables and an optional `.coveralls.yml` file.
  static Future<Configuration> loadDefaults([String coverallsFile = '.coveralls.yml']) async {
    var defaults = new Configuration.fromEnvironment();

    try {
      defaults.addAll(new Configuration.fromYaml(await fileSystem.file(coverallsFile).readAsString()));
      return defaults;
    }

    on Exception {
      return defaults;
    }
  }

  /// Removes the specified [key] and its associated value from this configuration.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key) => _params.remove(key);

  /// Converts this object to a [Map] in JSON format.
  Map<String, String> toJson() => _params;

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'Configuration ${JSON.encode(this)}';
}
