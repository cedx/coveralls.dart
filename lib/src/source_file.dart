part of coveralls;

/// Represents a source code file and its coverage data for a single job.
class SourceFile {

  /// Creates a new source file.
  SourceFile([this.name = '', this.sourceDigest = '', this.source = '', List<int> coverage]): coverage = coverage ?? [];

  /// Creates a new source file from the specified [map] in JSON format.
  SourceFile.fromJson(Map<String, dynamic> map):
    coverage = map['coverage'] is List<int> ? map['coverage'] : [],
    name = map['name'] is String ? map['name'] : '',
    source = map['source'] is String ? map['source'] : '',
    sourceDigest = map['source_digest'] is String ? map['source_digest'] : '';

  /// The coverage data for this file's job.
  final List<int> coverage;

  /// The file path of this source file.
  String name;

  /// The contents of this source file.
  String source;

  /// The MD5 digest of the full source code of this file.
  String sourceDigest;

  /// Converts this object to a map in JSON format.
  Map<String, dynamic> toJson() {
    var map = {
      'name': name,
      'source_digest': sourceDigest,
      'coverage': coverage
    };

    if (source.isNotEmpty) map['source'] = source;
    return map;
  }

  /// Returns a string representation of this object.
  @override
  String toString() => '$runtimeType ${JSON.encode(this)}';
}