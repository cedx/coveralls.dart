part of "../io.dart";

/// Represents a source code file and its coverage data for a single job.
@JsonSerializable()
class SourceFile {

	/// Creates a new source file.
	SourceFile(this.name, this.sourceDigest, {Iterable<int> branches, Iterable<int> coverage, this.source}):
		branches = branches?.toList(),
		coverage = coverage?.toList() ?? <int>[];

	/// Creates a new source file from the specified [map] in JSON format.
	factory SourceFile.fromJson(Map<String, dynamic> map) => _$SourceFileFromJson(map);

	/// The branch data for this file's job.
	@JsonKey(includeIfNull: false)
	final List<int> branches;

	/// The coverage data for this file's job.
	@JsonKey(defaultValue: [])
	final List<int> coverage;

	/// The file path of this source file.
	@JsonKey(defaultValue: "")
	final String name;

	/// The contents of this source file.
	@JsonKey(includeIfNull: false)
	final String source;

	/// The MD5 digest of the full source code of this file.
	@JsonKey(defaultValue: "", name: "source_digest")
	final String sourceDigest;

	/// Converts this object to a [Map] in JSON format.
	Map<String, dynamic> toJson() => _$SourceFileToJson(this);
}
