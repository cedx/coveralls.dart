part of '../io.dart';

/// Represents the coverage data from a single run of a test suite.
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Job {

  /// Creates a new job.
  Job({this.repoToken, this.serviceJobId, this.serviceName, Iterable<SourceFile> sourceFiles}): sourceFiles = sourceFiles?.toList() ?? <SourceFile>[];

  /// Creates a new job from the specified [map] in JSON format.
  factory Job.fromJson(Map<String, dynamic> map) => _$JobFromJson(map);

  /// The current SHA of the commit being built to override the [git] property.
  @JsonKey(name: 'commit_sha')
  String commitSha;

  /// A map of Git data that can be used to display more information to users.
  GitData git;

  /// Value indicating whether the build will not be considered done until a webhook has been sent to Coveralls.
  @JsonKey(name: 'parallel')
  bool isParallel;

  /// The secret token for the repository.
  @JsonKey(name: 'repo_token')
  String repoToken;

  /// A timestamp of when the job ran.
  @JsonKey(name: 'run_at')
  DateTime runAt;

  /// A unique identifier of the job on the CI service.
  @JsonKey(name: 'service_job_id')
  String serviceJobId;

  /// The CI service or other environment in which the test suite was run.
  @JsonKey(name: 'service_name')
  String serviceName;

  /// The build number.
  @JsonKey(name: 'service_number')
  String serviceNumber;

  /// The associated pull request ID of the build.
  @JsonKey(name: 'service_pull_request')
  String servicePullRequest;

  /// The list of source files.
  @JsonKey(defaultValue: [], name: 'source_files')
  final List<SourceFile> sourceFiles;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson()  => _$JobToJson(this);
}
