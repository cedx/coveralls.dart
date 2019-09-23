import 'dart:io';
import 'package:coveralls/coveralls.dart';
import 'package:crypto/crypto.dart';
import 'package:lcov/lcov.dart';
import 'package:path/path.dart' as p;

/// Parses the specified [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) coverage report.
Future<Job> parseReport(String report) async {
  final sourceFiles = <SourceFile>[];
  for (final record in Report.fromCoverage(report).records) {
    final source = await File(record.sourceFile).readAsString();
    final lineCoverage = List<int>(source.split(RegExp(r'\r?\n')).length);
    if (record.lines != null) for (final lineData in record.lines.data) lineCoverage[lineData.lineNumber - 1] = lineData.executionCount;

    final branchCoverage = <int>[];
    if (record.branches != null) for (final branchData in record.branches.data) branchCoverage.addAll(<int>[
      branchData.lineNumber,
      branchData.blockNumber,
      branchData.branchNumber,
      branchData.taken
    ]);

    final filename = p.relative(record.sourceFile);
    final digest = md5.convert(source.codeUnits).toString();
    sourceFiles.add(SourceFile(
      filename,
      digest,
      branches: branchCoverage.isEmpty ? null : branchCoverage,
      coverage: lineCoverage,
      source: source
    ));
  }

  return Job(sourceFiles: sourceFiles);
}
