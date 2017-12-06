import 'package:coveralls/coveralls.dart';
import 'package:coveralls/src/parsers/clover.dart';
import 'package:test/test.dart';

/// Tests the features of the Clover parser.
void main() => group('Clover', () {
  final path = fileSystem.path;

  group('parseReport()', () {
    test('should properly parse Clover reports', () async {
      var job = await parseReport(await fileSystem.file('test/fixtures/clover.xml').readAsString());
      expect(job.sourceFiles, hasLength(3));

      expect(job.sourceFiles.first.name, equals(path.join('lib', 'src', 'client.dart')));
      expect(job.sourceFiles.first.sourceDigest, isNotEmpty);
      expect(job.sourceFiles.first.coverage, containsAllInOrder([null, 2, 2, 2, 2, null]));

      expect(job.sourceFiles[1].name, equals(path.join('lib', 'src', 'configuration.dart')));
      expect(job.sourceFiles[1].sourceDigest, isNotEmpty);
      expect(job.sourceFiles[1].coverage, containsAllInOrder([null, 4, 4, 2, 2, 4, 2, 2, 4, 4, null]));

      expect(job.sourceFiles[2].name, equals(path.join('lib', 'src', 'git_commit.dart')));
      expect(job.sourceFiles[2].sourceDigest, isNotEmpty);
      expect(job.sourceFiles[2].coverage, containsAllInOrder([null, 2, 2, 2, 2, 2, 0, 0, 2, 2, null]));
    });

    test('should throw an excepton if the Clover report is invalid', () {
      expect(parseReport('<coverage><foo /></coverage>'), throwsFormatException);
    });
  });
});
