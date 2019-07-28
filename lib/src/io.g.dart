// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'io.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitCommit _$GitCommitFromJson(Map<String, dynamic> json) {
  return GitCommit(
    json['id'] as String,
    authorEmail: json['author_email'] as String,
    authorName: json['author_name'] as String,
    committerEmail: json['committer_email'] as String,
    committerName: json['committer_name'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$GitCommitToJson(GitCommit instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('author_email', instance.authorEmail);
  writeNotNull('author_name', instance.authorName);
  writeNotNull('committer_email', instance.committerEmail);
  writeNotNull('committer_name', instance.committerName);
  writeNotNull('id', instance.id);
  writeNotNull('message', instance.message);
  return val;
}

GitData _$GitDataFromJson(Map<String, dynamic> json) {
  return GitData(
    json['head'] == null
        ? null
        : GitCommit.fromJson(json['head'] as Map<String, dynamic>),
    branch: json['branch'] as String ?? '',
    remotes: (json['remotes'] as List)?.map((e) =>
            e == null ? null : GitRemote.fromJson(e as Map<String, dynamic>)) ??
        [],
  );
}

Map<String, dynamic> _$GitDataToJson(GitData instance) => <String, dynamic>{
      'branch': instance.branch,
      'head': instance.commit?.toJson(),
      'remotes': instance.remotes?.map((e) => e?.toJson())?.toList(),
    };

GitRemote _$GitRemoteFromJson(Map<String, dynamic> json) {
  return GitRemote(
    json['name'] as String ?? '',
    json['url'],
  );
}

Map<String, dynamic> _$GitRemoteToJson(GitRemote instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url?.toString(),
    };

Job _$JobFromJson(Map<String, dynamic> json) {
  return Job(
    repoToken: json['repo_token'] as String,
    serviceJobId: json['service_job_id'] as String,
    serviceName: json['service_name'] as String,
    sourceFiles: (json['source_files'] as List)?.map((e) => e == null
            ? null
            : SourceFile.fromJson(e as Map<String, dynamic>)) ??
        [],
  )
    ..commitSha = json['commit_sha'] as String
    ..git = json['git'] == null
        ? null
        : GitData.fromJson(json['git'] as Map<String, dynamic>)
    ..isParallel = json['parallel'] as bool
    ..runAt =
        json['run_at'] == null ? null : DateTime.parse(json['run_at'] as String)
    ..serviceNumber = json['service_number'] as String
    ..servicePullRequest = json['service_pull_request'] as String;
}

Map<String, dynamic> _$JobToJson(Job instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('commit_sha', instance.commitSha);
  writeNotNull('git', instance.git?.toJson());
  writeNotNull('parallel', instance.isParallel);
  writeNotNull('repo_token', instance.repoToken);
  writeNotNull('run_at', instance.runAt?.toIso8601String());
  writeNotNull('service_job_id', instance.serviceJobId);
  writeNotNull('service_name', instance.serviceName);
  writeNotNull('service_number', instance.serviceNumber);
  writeNotNull('service_pull_request', instance.servicePullRequest);
  writeNotNull(
      'source_files', instance.sourceFiles?.map((e) => e?.toJson())?.toList());
  return val;
}

SourceFile _$SourceFileFromJson(Map<String, dynamic> json) {
  return SourceFile(
    json['name'] as String ?? '',
    json['source_digest'] as String ?? '',
    coverage: (json['coverage'] as List)?.map((e) => e as int) ?? [],
    source: json['source'] as String,
  );
}

Map<String, dynamic> _$SourceFileToJson(SourceFile instance) {
  final val = <String, dynamic>{
    'coverage': instance.coverage,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('source', instance.source);
  val['source_digest'] = instance.sourceDigest;
  return val;
}
