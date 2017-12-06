part of coveralls;

/// Represents Git data that can be used to display more information to users.
class GitData {

  /// Creates a new data.
  GitData(this.commit, {this.branch = '', List<GitRemote> remotes}): remotes = new List.from(remotes ?? const []);

  /// Creates a new data from the specified [map] in JSON format.
  GitData.fromJson(Map<String, dynamic> map):
    branch = map['branch'] is String ? map['branch'] : '',
    commit = map['head'] is Map<String, String> ? new GitCommit.fromJson(map['head']) : null,
    remotes = map['remotes'] is List<Map<String, String>> ? map['remotes'].map((item) => new GitRemote.fromJson(item)).toList() : [];

  /// The branch name.
  String branch;

  /// The Git commit.
  final GitCommit commit;

  /// The remote repositories.
  final List<GitRemote> remotes;

  /// Creates a new Git data from a repository located at the specified [path] (defaulting to the current working directory).
  /// This method relies on the availability of the Git executable in the system path.
  static Future<GitData> fromRepository([String path = '']) async {
    var commands = {
      'authorEmail': 'log -1 --pretty=format:%ae',
      'authorName': 'log -1 --pretty=format:%aN',
      'branch': 'rev-parse --abbrev-ref HEAD',
      'committerEmail': 'log -1 --pretty=format:%ce',
      'committerName': 'log -1 --pretty=format:%cN',
      'id': 'log -1 --pretty=format:%H',
      'message': 'log -1 --pretty=format:%s',
      'remotes': 'remote -v'
    };

    var workingDir = path.isNotEmpty ? path : fileSystem.currentDirectory.path;
    for (var key in commands.keys) {
      var result = await processManager.run(['git']..addAll(commands[key].split(' ')), workingDirectory: workingDir);
      commands[key] = result.stdout.trim();
    }

    var remotes = {};
    for (var remote in commands['remotes'].split(new RegExp(r'\r?\n'))) {
      var parts = remote.replaceAll(new RegExp(r'\s+'), ' ').split(' ');
      remotes.putIfAbsent(parts.first, () => new GitRemote(parts.first, parts.length > 1 ? Uri.parse(parts[1]) : null));
    }

    return new GitData(new GitCommit.fromJson(commands), branch: commands['branch'], remotes: remotes.values.toList());
  }

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => {
    'branch': branch,
    'head': commit?.toJson(),
    'remotes': remotes.map((item) => item.toJson()).toList()
  };

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'GitData ${JSON.encode(this)}';
}
