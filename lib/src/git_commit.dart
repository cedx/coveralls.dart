part of coveralls;

/// Represents a Git commit.
class GitCommit {

  /// Creates a new commit.
  const GitCommit(this.id, {this.authorEmail = '', this.authorName = '', this.committerEmail = '', this.committerName = '', this.message = ''});

  /// Creates a new commit from the specified [map] in JSON format.
  GitCommit.fromJson(Map<String, String> map):
    authorEmail = map['author_email'] ?? '',
    authorName = map['author_name'] ?? '',
    committerEmail = map['committer_email'] ?? '',
    committerName = map['committer_name'] ?? '',
    id = map['id'] ?? '',
    message = map['message'] ?? '';

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
  Map<String, dynamic> toJson() {
    var map = {'id': id};
    if (authorEmail.isNotEmpty) map['author_email'] = authorEmail;
    if (authorName.isNotEmpty) map['author_name'] = authorName;
    if (committerEmail.isNotEmpty) map['committer_email'] = committerEmail;
    if (committerName.isNotEmpty) map['committer_name'] = committerName;
    if (message.isNotEmpty) map['message'] = message;
    return map;
  }

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'GitCommit ${JSON.encode(this)}';
}
