import 'dart:async';
import 'dart:io';
import 'package:coveralls/coveralls.dart';
import 'package:crypto/crypto.dart';
import 'package:lcov/lcov.dart';
import 'package:path/path.dart' as path;

/// Parses the specified [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) coverage report.
Future<Job> parseReport(String report) async {
  var sourceFiles = <SourceFile>[];
  for (var record in new Report.fromCoverage(report).records) {
    var source = await new File(record.sourceFile).readAsString();
    var coverage = new List<int>(source.split(new RegExp(r'\r?\n')).length);
    for (var lineData in record.lines.data) coverage[lineData.lineNumber - 1] = lineData.executionCount;

    var filename = path.relative(record.sourceFile);
    var digest = md5.convert(source.codeUnits).toString();
    sourceFiles.add(new SourceFile(filename, digest, coverage: coverage, source: source));
  }

  return new Job(sourceFiles: sourceFiles);
}
