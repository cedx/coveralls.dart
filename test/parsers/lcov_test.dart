import 'dart:io';
import 'package:coveralls/src/io/parsers/lcov.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Tests the features of the LCOV parser.
void main() => group('Lcov', () {
  group('parseReport()', () {
    test('should properly parse LCOV reports', () async {
      final job = await parseReport(await File('test/fixtures/lcov.info').readAsString());
      expect(job.sourceFiles, hasLength(3));

      expect(job.sourceFiles.first.name, p.join('lib', 'src', 'io', 'client.dart'));
      expect(job.sourceFiles.first.sourceDigest, isNotEmpty);
      expect(job.sourceFiles.first.branches, isNull);
      expect(job.sourceFiles.first.coverage, containsAllInOrder([null, 2, 2, 2, 2, null]));

      expect(job.sourceFiles[1].name, p.join('lib', 'src', 'io', 'configuration.dart'));
      expect(job.sourceFiles[1].sourceDigest, isNotEmpty);
      expect(job.sourceFiles[1].branches, containsAllInOrder([8, 0, 0, 2, 8, 0, 1, 2, 11, 0, 0, 2, 11, 0, 1, 2]));
      expect(job.sourceFiles[1].coverage, containsAllInOrder([null, 4, 4, 2, 2, 4, 2, 2, 4, 4, null]));

      expect(job.sourceFiles[2].name, p.join('lib', 'src', 'io', 'git.dart'));
      expect(job.sourceFiles[2].sourceDigest, isNotEmpty);
      expect(job.sourceFiles[2].branches, containsAllInOrder([8, 0, 0, 2, 8, 0, 1, 0, 11, 0, 0, 0, 11, 0, 1, 2]));
      expect(job.sourceFiles[2].coverage, containsAllInOrder([null, 2, 2, 2, 2, 2, 0, 0, 2, 2, null]));
    });
  });
});
