import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:lcov/lcov.dart';
import 'package:path/path.dart' as p;
import '../../io.dart';

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

    sourceFiles.add(SourceFile(
      p.isAbsolute(record.sourceFile) ? p.relative(record.sourceFile) : record.sourceFile,
      md5.convert(source.codeUnits).toString(),
      branches: branchCoverage.isEmpty ? null : branchCoverage,
      coverage: lineCoverage,
      source: source
    ));
  }

  return Job(sourceFiles: sourceFiles);
}
