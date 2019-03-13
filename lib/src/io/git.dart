part of '../io.dart';

/// Represents a Git commit.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class GitCommit {

  /// Creates a new commit.
  const GitCommit(this.id, {this.authorEmail, this.authorName, this.committerEmail, this.committerName, this.message});

  /// Creates a new commit from the specified [map] in JSON format.
  factory GitCommit.fromJson(Map<String, dynamic> map) => _$GitCommitFromJson(map);

  /// The author mail address.
  final String authorEmail;

  /// The author name.
  final String authorName;

  /// The committer mail address.
  final String committerEmail;

  /// The committer name.
  final String committerName;

  /// The commit identifier.
  final String id;

  /// The commit message.
  final String message;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => _$GitCommitToJson(this);

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'GitCommit ${json.encode(this)}';
}

/// Represents Git data that can be used to display more information to users.
@JsonSerializable(explicitToJson: true)
class GitData {

  /// Creates a new data.
  GitData(this.commit, {this.branch = '', Iterable<GitRemote> remotes}): remotes = remotes?.toList() ?? <GitRemote>[];

  /// Creates a new data from the specified [map] in JSON format.
  factory GitData.fromJson(Map<String, dynamic> map) => _$GitDataFromJson(map);

  /// The branch name.
  @JsonKey(defaultValue: '')
  String branch;

  /// The Git commit.
  @JsonKey(name: 'head')
  final GitCommit commit;

  /// The remote repositories.
  @JsonKey(defaultValue: [])
  final List<GitRemote> remotes;

  /// Creates a new Git data from a repository located at the specified [path] (defaulting to the current working directory).
  /// This method relies on the availability of the Git executable in the system path.
  static Future<GitData> fromRepository([String path = '']) async {
    final commands = {
      'authorEmail': 'log -1 --pretty=format:%ae',
      'authorName': 'log -1 --pretty=format:%aN',
      'branch': 'rev-parse --abbrev-ref HEAD',
      'committerEmail': 'log -1 --pretty=format:%ce',
      'committerName': 'log -1 --pretty=format:%cN',
      'id': 'log -1 --pretty=format:%H',
      'message': 'log -1 --pretty=format:%s',
      'remotes': 'remote -v'
    };

    final workingDir = path.isNotEmpty ? path : Directory.current.path;
    for (final key in commands.keys) {
      final result = await Process.run('git', commands[key].split(' '), workingDirectory: workingDir);
      commands[key] = result.stdout.trim();
    }

    final remotes = <String, GitRemote>{};
    for (final remote in commands['remotes'].split(RegExp(r'\r?\n'))) {
      final parts = remote.replaceAll(RegExp(r'\s+'), ' ').split(' ');
      remotes.putIfAbsent(parts.first, () => GitRemote(parts.first, parts.length > 1 ? parts[1] : null));
    }

    return GitData(GitCommit.fromJson(commands), branch: commands['branch'], remotes: remotes.values);
  }

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => _$GitDataToJson(this);

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'GitData ${json.encode(this)}';
}

/// Represents a Git remote repository.
@JsonSerializable()
class GitRemote {

  /// Creates a new remote repository.
  GitRemote(this.name, [url]): url = url is! String ? url : Uri.parse(RegExp(r'^\w+://').hasMatch(url) ? url : url.replaceFirstMapped(
    RegExp(r'^([^@]+@)?([^:]+):(.+)$'),
    (match) => 'ssh://${match[1]}${match[2]}/${match[3]}')
  );

  /// Creates a new source file from the specified [map] in JSON format.
  factory GitRemote.fromJson(Map<String, dynamic> map) => _$GitRemoteFromJson(map);

  /// The remote's name.
  @JsonKey(defaultValue: '')
  final String name;

  /// The remote's URL.
  final Uri url;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => _$GitRemoteToJson(this);

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'GitRemote ${json.encode(this)}';
}
