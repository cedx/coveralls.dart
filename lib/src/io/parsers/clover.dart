import "dart:io";
import "package:crypto/crypto.dart";
import "package:path/path.dart" as p;
import "package:xml/xml.dart";
import "../../io.dart";

/// Parses the specified [Clover](https://www.atlassian.com/software/clover) coverage report.
/// Throws a [FormatException] if a parsing error occurred.
Future<Job> parseReport(String report) async {
	final xml = XmlDocument.parse(report);
	if (xml.findAllElements("project").isEmpty) throw FormatException("The specified Clover report is invalid.", report);

	final sourceFiles = <SourceFile>[];
	for (final file in xml.findAllElements("file")) {
		final sourceFile = file.getAttribute("name");
		if (sourceFile == null || sourceFile.isEmpty) throw FormatException("Invalid file data: ${file.toXmlString()}", report);

		final source = await File(sourceFile).readAsString();
		final coverage = List<int>(source.split(RegExp(r"\r?\n")).length);

		for (final line in file.findAllElements("line")) {
			if (line.getAttribute("type") != "stmt") continue;
			final lineNumber = int.parse(line.getAttribute("num"), radix: 10);
			coverage[lineNumber - 1] = int.parse(line.getAttribute("count"), radix: 10);
		}

		final filename = p.isAbsolute(sourceFile) ? p.relative(sourceFile) : p.normalize(sourceFile);
		final digest = md5.convert(source.codeUnits).toString();
		sourceFiles.add(SourceFile(filename, digest, coverage: coverage, source: source));
	}

	return Job(sourceFiles: sourceFiles);
}
