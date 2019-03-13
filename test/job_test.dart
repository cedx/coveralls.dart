import 'package:coveralls/coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the [Job] class.
void main() => group('Job', () {
  group('.fromJson()', () {
    test('should return an instance with default values for an empty map', () {
      final job = Job.fromJson({});
      expect(job, isNotNull);
      expect(job.git, isNull);
      expect(job.isParallel, isNull);
      expect(job.repoToken, isNull);
      expect(job.runAt, isNull);
      expect(job.sourceFiles, isEmpty);
    });

    test('should return an initialized instance for a non-empty map', () {
      final job = Job.fromJson({
        'git': {'branch': 'develop'},
        'parallel': true,
        'repo_token': 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt',
        'run_at': '2017-01-29T02:43:30.000Z',
        'source_files': [{'name': '/home/cedx/coveralls.dart'}]
      });

      expect(job, isNotNull);
      expect(job.isParallel, isTrue);
      expect(job.repoToken, 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt');

      expect(job.git, isNotNull);
      expect(job.git.branch, 'develop');

      expect(job.runAt, isNotNull);
      expect(job.runAt.toIso8601String(), '2017-01-29T02:43:30.000Z');

      expect(job.sourceFiles, hasLength(1));
      expect(job.sourceFiles.first, isNotNull);
      expect(job.sourceFiles.first.name, '/home/cedx/coveralls.dart');
    });
  });

  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      final map = Job().toJson();
      expect(map, hasLength(1));
      expect(map['source_files'], allOf(isList, isEmpty));
    });

    test('should return a non-empty map for an initialized instance', () {
      final job = Job(repoToken: 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt')
        ..git = GitData(null, branch: 'develop')
        ..isParallel = true
        ..runAt = DateTime.parse('2017-01-29T02:43:30.000Z')
        ..sourceFiles.add(SourceFile('/home/cedx/coveralls.dart', ''));

      final map = job.toJson();
      expect(map, hasLength(5));
      expect(map['parallel'], isTrue);
      expect(map['repo_token'], 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt');
      expect(map['run_at'], '2017-01-29T02:43:30.000Z');

      expect(map['git'], isMap);
      expect(map['git']['branch'], 'develop');

      expect(map['source_files'], allOf(isList, hasLength(1)));
      expect(map['source_files'].first, isMap);
      expect(map['source_files'].first['name'], '/home/cedx/coveralls.dart');
    });
  });

  group('.toString()', () {
    final job = Job(repoToken: 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt')
      ..git = GitData(null, branch: 'develop')
      ..isParallel = true
      ..runAt = DateTime.parse('2017-01-29T02:43:30.000Z')
      ..sourceFiles.add(SourceFile('/home/cedx/coveralls.dart', ''));

    final data = job.toString();
    test('should start with the class name', () {
      expect(data.indexOf('Job {'), 0);
    });

    test('should contain the instance properties', () {
      expect(data, contains('"git":{'));
      expect(data, contains('"parallel":true'));
      expect(data, contains('"repo_token":"yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt"'));
      expect(data, contains('"run_at":"2017-01-29T02:43:30.000Z"'));
      expect(data, contains('"source_files":[{'));
    });
  });
});
