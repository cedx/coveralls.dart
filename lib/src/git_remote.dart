part of coveralls;

/// Represents a Git remote repository.
class GitRemote {

  /// Creates a new remote repository.
  GitRemote(this.name, [this.url]);

  /// Creates a new source file from the specified [map] in JSON format.
  GitRemote.fromJson(Map<String, String> map):
    name = map['name'] ?? '',
    url = map['url'] != null ? Uri.parse(map['url']) : null;

  /// The remote's name.
  final String name;

  /// The remote's URL.
  final Uri url;

  /// Converts this object to a [Map] in JSON format.
  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url?.toString()
  };

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'GitRemote ${JSON.encode(this)}';
}
