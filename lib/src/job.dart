part of coveralls;

/// Represents the coverage data from a single run of a test suite.
class Job {

  /// Creates a new job.
  Job({this.repoToken = '', this.serviceJobId = '', this.serviceName = '', List<SourceFile> sourceFiles}):
    sourceFiles = new List.from(sourceFiles ?? const []);

  /// Creates a new job from the specified [map] in JSON format.
  Job.fromJson(Map<String, dynamic> map):
    commitSha = map['commit_sha'] is String ? map['commit_sha'] : '',
    git = map['git'] is Map<String, dynamic> ? new GitData.fromJson(map['git']) : null,
    isParallel = map['parallel'] is bool ? map['parallel'] : false,
    repoToken = map['repo_token'] is String ? map['repo_token'] : '',
    runAt = map['run_at'] is String ? DateTime.parse(map['run_at']) : null,
    serviceJobId = map['service_job_id'] is String ? map['service_job_id'] : '',
    serviceName = map['service_name'] is String ? map['service_name'] : '',
    serviceNumber = map['service_number'] is String ? map['service_number'] : '',
    servicePullRequest = map['service_pull_request'] is String ? map['service_pull_request'] : '',
    sourceFiles = map['source_files'] is List<Map> ? map['source_files'].map((item) => new SourceFile.fromJson(item)).toList() : [];

  /// The current SHA of the commit being built to override the [git] property.
  String commitSha = '';

  /// A map of Git data that can be used to display more information to users.
  GitData git;

  /// Value indicating whether the build will not be considered done until a webhook has been sent to Coveralls.
  bool isParallel = false;

  /// The secret token for the repository.
  String repoToken;

  /// A timestamp of when the job ran.
  DateTime runAt;

  /// A unique identifier of the job on the CI service.
  String serviceJobId;

  /// The CI service or other environment in which the test suite was run.
  String serviceName;

  /// The build number.
  String serviceNumber = '';

  /// The associated pull request ID of the build.
  String servicePullRequest = '';

  /// The list of source files.
  final List<SourceFile> sourceFiles;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() {
    var map = {};
    if (repoToken.isNotEmpty) map['repo_token'] = repoToken;
    if (serviceName.isNotEmpty) map['service_name'] = serviceName;
    if (serviceNumber.isNotEmpty) map['service_number'] = serviceNumber;
    if (serviceJobId.isNotEmpty) map['service_job_id'] = serviceJobId;
    if (servicePullRequest.isNotEmpty) map['service_pull_request'] = servicePullRequest;

    map['source_files'] = sourceFiles.map((item) => item.toJson()).toList();
    if (isParallel) map['parallel'] = true;
    if (git != null) map['git'] = git.toJson();
    if (commitSha.isNotEmpty) map['commit_sha'] = commitSha;
    if (runAt != null) map['run_at'] = runAt.toIso8601String();

    return map;
  }

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'Job ${JSON.encode(this)}';
}
