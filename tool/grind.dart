import 'package:grinder/grinder.dart';

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

@DefaultTask('Builds the project')
void build() => Pub.run('build_runner', arguments: ['build', '--delete-conflicting-outputs']);

@Task('Deletes all generated files and reset any saved state')
void clean() {
  defaultClean();
  delete(getFile('var/lcov.info'));
  ['.dart_tool/build', 'var/test', 'www'].map(getDir).forEach(delete);
}

@Task('Uploads the results of the code coverage')
void coverage() {
  final arguments = ['--in=var/test', '--lcov', '--out=var/lcov.info', '--packages=.packages', '--report-on=lib'];
  Pub.run('coverage', script: 'format_coverage', arguments: arguments);
  Dart.run('${binDir.path}/coveralls.dart', arguments: ['var/lcov.info']);
}

@Task('Builds the documentation')
void doc() => run('mkdocs', arguments: ['build', '--config-file=mkdocs.yaml']);

@Task('Fixes the coding standards issues')
void fix() => DartFmt.format(existingSourceDirs);

@Task('Performs the static analysis of source code')
void lint() => Analyzer.analyze(existingSourceDirs);

@Task('Publishes the package to the registry')
@Depends(clean, fix)
void publish() => run('pub', arguments: ['publish', '--force'], runOptions: RunOptions(runInShell: true));

@Task('Runs the test suites')
@Depends(build)
void test() => Pub.run('test', arguments: ['--coverage=var']);

@Task('Upgrades the project to the latest revision')
void upgrade() {
  run('git', arguments: ['reset', '--hard']);
  run('git', arguments: ['fetch', '--all', '--prune']);
  run('git', arguments: ['pull', '--rebase']);
  Pub.upgrade();
}

@Task('Watches for file changes')
void watch() => Pub.run('build_runner', arguments: ['watch', '--delete-conflicting-outputs']);
