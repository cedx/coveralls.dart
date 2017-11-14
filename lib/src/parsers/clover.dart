import 'dart:async';
import 'dart:math' as math;
import 'package:coveralls/coveralls.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart' as xml;

/// Parses the specified [Clover](https://www.atlassian.com/software/clover) coverage report.
/// Throws a [FormatException] if a parsing error occurred.
Future<Job> parseReport(String report) async {
  var coverage = xml.parse(report);
  if (coverage.findAllElements('project').isEmpty) throw new FormatException('The specified Clover report is invalid.', report);

  var sourceFiles = <SourceFile>[];
  for (var file in xml.parse(report).findAllElements('file')) {
    var sourceFile = file.getAttribute('name');
    if (sourceFile == null || sourceFile.isEmpty) throw new FormatException('Invalid file data: ${file.toXmlString()}', report);

    var source = await fileSystem.file(sourceFile).readAsString();
    var coverage = new List<int>(source.split(new RegExp(r'\r?\n')).length);

    for (var line in file.findAllElements('line')) {
      if (line.getAttribute('type') != 'stmt') continue;
      var lineNumber = math.max(1, int.parse(line.getAttribute('num'), radix: 10));
      coverage[lineNumber - 1] = math.max(0, int.parse(line.getAttribute('count'), radix: 10));
    }

    var filename = path.relative(sourceFile);
    var digest = md5.convert(source.codeUnits).toString();
    sourceFiles.add(new SourceFile(filename, digest, coverage: coverage, source: source));
  }

  return new Job(sourceFiles: sourceFiles);
}
