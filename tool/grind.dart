import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:grinder/grinder.dart' hide ProcessException;

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

@DefaultTask('Builds the project')
void build() => Pub.run('build_runner', arguments: ['build', '--delete-conflicting-outputs']);

@Task('Deletes all generated files and reset any saved state')
void clean() {
  defaultClean();
  ['.dart_tool', 'doc/api', webDir.path].map(getDir).forEach(delete);
  ['var/lcov.info'].map(getFile).forEach(delete);
}

@Task('Uploads the results of the code coverage')
void coverage() => Dart.run('${binDir.path}/coveralls.dart', arguments: ['var/lcov.info']);

@Task('Builds the documentation')
Future<void> doc() async {
  for (final path in ['CHANGELOG.md', 'LICENSE.md']) await getFile(path).copy('doc/about/${path.toLowerCase()}');
  DartDoc.doc();
  run('mkdocs', arguments: ['build', '--config-file=doc/mkdocs.yml']);
  ['doc/about/changelog.md', 'doc/about/license.md', '${webDir.path}/mkdocs.yml'].map(getFile).forEach(delete);
}

@Task('Fixes the coding standards issues')
void fix() => DartFmt.format(existingSourceDirs);

@Task('Performs the static analysis of source code')
void lint() => Analyzer.analyze(existingSourceDirs);

@Task('Runs the test suites')
Future<void> test() => _profileTest('test/all.dart', 'var/lcov.info');

@Task('Upgrades the project to the latest revision')
void upgrade() {
  run('git', arguments: ['reset', '--hard']);
  run('git', arguments: ['fetch', '--all', '--prune']);
  run('git', arguments: ['pull', '--rebase']);
  Pub.upgrade();
}

@Task('Watches for file changes')
void watch() => Pub.run('build_runner', arguments: ['watch', '--delete-conflicting-outputs']);

/// Profiles the execution of the specified [source] test file,
/// and writes the resulting code coverage to the given [output] file.
Future<void> _profileTest(source, output) async {
  final inputFile = FilePath(source).asFile;
  final serviceUriCompleter = Completer<Uri>();

  final process = await Process.start('dart', ['--enable-vm-service', '--pause-isolates-on-exit', inputFile.path]);
  process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(log);
  process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
    log(line);
    if (!serviceUriCompleter.isCompleted) {
      final match = RegExp(r'^Observatory listening on (.*)$').firstMatch(line);
      final uri = match != null ? match[1].trim() : 'http://127.0.0.1:8181/';
      serviceUriCompleter.complete(Uri.parse(uri));
    }
  });

  final coverage = joinFile(Directory.systemTemp, ['dart_coverage_${DateTime.now().millisecondsSinceEpoch}.json']);
  var arguments = ['--out=${coverage.path}', '--resume-isolates', '--uri=${await serviceUriCompleter.future}', '--wait-paused'];
  await Pub.runAsync('coverage', script: 'collect_coverage', arguments: arguments);

  final exitCode = await process.exitCode;
  if (exitCode != 0) throw ProcessException(inputFile.absolute.path, [], 'Script terminated with exit code $exitCode.', exitCode);

  arguments = ['--in=${coverage.path}', '--lcov', '--out=${FilePath(output).asFile.path}', '--packages=.packages', '--report-on=${libDir.path}'];
  return Pub.runAsync('coverage', script: 'format_coverage', arguments: arguments);
}
