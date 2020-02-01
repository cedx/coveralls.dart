part of '../io.dart';

/// Uploads code coverage reports to the [Coveralls](https://coveralls.io) service.
class Client {

  /// Creates a new client.
  Client([Uri endPoint]): endPoint = endPoint ?? defaultEndPoint;

  /// The URL of the default API end point.
  static final Uri defaultEndPoint = Uri.https('coveralls.io', '/api/v1/');

  /// The handler of "request" events.
  final StreamController<http.MultipartRequest> _onRequest = StreamController<http.MultipartRequest>.broadcast();

  /// The handler of "response" events.
  final StreamController<http.Response> _onResponse = StreamController<http.Response>.broadcast();

  /// The URL of the API end point.
  final Uri endPoint;

  /// The stream of "request" events.
  Stream<http.MultipartRequest> get onRequest => _onRequest.stream;

  /// The stream of "response" events.
  Stream<http.Response> get onResponse => _onResponse.stream;

  /// Uploads the specified code [coverage] report to the Coveralls service.
  /// A [configuration] object provides the environment settings.
  ///
  /// Completes with a [FormatException] if the format of the specified coverage report is not supported.
  Future<void> upload(String coverage, [Configuration configuration]) async {
    assert(coverage.isNotEmpty);

    Job job;
    if (report.startsWith('<?xml') || report.startsWith('<coverage')) {
      await clover.loadLibrary();
      job = await clover.parseReport(report);
    }
    else if (report.startsWith('TN:') || report.startsWith('SF:')) {
      await lcov.loadLibrary();
      job = await lcov.parseReport(report);
    }

    if (job == null) throw FormatException('The specified coverage format is not supported.', report);
    _updateJob(job, configuration ?? await Configuration.loadDefaults());
    job.runAt ??= DateTime.now();

    try {
      await where('git');
      final git = await GitData.fromRepository();
      final branch = job.git != null ? job.git.branch : '';
      if (git.branch == 'HEAD' && branch.isNotEmpty) git.branch = branch;
      job.git = git;
    }

    on FinderException { /* Noop */ }
    return uploadJob(job);
  }

  /// Uploads the specified [job] to the Coveralls service.
  ///
  /// Completes with an [ArgumentError] if the job does not meet the requirements.
  /// Completes with a [http.ClientException] if the remote service does not respond successfully.
  Future<void> uploadJob(Job job) async {
    if (job.repoToken == null && job.serviceName == null)
      throw ArgumentError.value(job, 'job', 'The job does not meet the requirements.');

    final httpClient = http.Client();
    final request = http.MultipartRequest('POST', endPoint.resolve('jobs'))
      ..files.add(http.MultipartFile.fromString('json_file', jsonEncode(job), filename: 'coveralls.json'));

    _onRequest.add(request);

    http.Response response;
    try { response = await http.Response.fromStream(await httpClient.send(request)); }
    on Exception catch (err) { throw http.ClientException(err.toString(), request.url); }

    _onResponse.add(response);
    httpClient.close();
    if ((response.statusCode ~/ 100) != 2) throw http.ClientException(response.body, request.url);
  }

  /// Updates the properties of the specified [job] using the given [configuration] parameters.
  void _updateJob(Job job, Configuration configuration) {
    if (configuration.containsKey('repo_token')) job.repoToken = configuration['repo_token'];
    else if (configuration.containsKey('repo_secret_token')) job.repoToken = configuration['repo_secret_token'];

    if (configuration.containsKey('parallel')) job.isParallel = configuration['parallel'] == 'true';
    if (configuration.containsKey('run_at')) job.runAt = DateTime.parse(configuration['run_at']);
    if (configuration.containsKey('service_job_id')) job.serviceJobId = configuration['service_job_id'];
    if (configuration.containsKey('service_name')) job.serviceName = configuration['service_name'];
    if (configuration.containsKey('service_number')) job.serviceNumber = configuration['service_number'];
    if (configuration.containsKey('service_pull_request')) job.servicePullRequest = configuration['service_pull_request'];

    final hasGitData = configuration.keys.any((key) => key == 'service_branch' || key.startsWith('git_'));
    if (!hasGitData) job.commitSha = configuration['commit_sha'] ?? '';
    else {
      final commit = GitCommit(
        configuration['commit_sha'] ?? '',
        authorEmail: configuration['git_author_email'] ?? '',
        authorName: configuration['git_author_name'] ?? '',
        committerEmail: configuration['git_committer_email'] ?? '',
        committerName: configuration['git_committer_email'] ?? '',
        message: configuration['git_message'] ?? ''
      );

      job.git = GitData(commit, branch: configuration['service_branch'] ?? '');
    }
  }
}
