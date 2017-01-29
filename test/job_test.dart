import 'package:coveralls/coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the [Job] class.
void main() => group('Job', () {
  group('constructor', () {
    test('should return an instance with default values for an empty map', () {
      var job = new Job();
      expect(job.git, isNull);
      expect(job.isParallel, isFalse);
      expect(job.repoToken, isEmpty);
      expect(job.runAt, isNull);
      expect(job.sourceFiles, allOf(isList, isEmpty));
    });

    test('should return an initialized instance for a non-empty map', () {
      var job = new Job(new Configuration({
        'parallel': 'true',
        'repo_token': 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt',
        'run_at': '2017-01-29T02:43:30.000Z',
        'service_branch': 'develop'
      }), [new SourceFile('/home/cedx/coveralls.php')]);

      expect(job.isParallel, isTrue);
      expect(job.repoToken, equals('yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt'));

      expect(job.git, new isInstanceOf<GitData>());
      expect(job.git.branch, equals('develop'));

      expect(job.runAt, new isInstanceOf<DateTime>());
      expect(job.runAt.toIso8601String(), equals('2017-01-29T02:43:30.000Z'));

      expect(job.sourceFiles, allOf(isList, hasLength(1)));
      expect(job.sourceFiles[0], new isInstanceOf<SourceFile>());
      expect(job.sourceFiles[0].name, equals('/home/cedx/coveralls.php'));
    });
  });

  group('.fromJson()', () {
    test('should return an instance with default values for an empty map', () {
      var job = new Job.fromJson(const {});
      expect(job, new isInstanceOf<Job>());
      expect(job.git, isNull);
      expect(job.isParallel, isFalse);
      expect(job.repoToken, isEmpty);
      expect(job.runAt, isNull);
      expect(job.sourceFiles, allOf(isList, isEmpty));
    });

    test('should return an initialized instance for a non-empty map', () {
      var job = new Job.fromJson({
        'git': {'branch': 'develop'},
        'parallel': true,
        'repo_token': 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt',
        'run_at': '2017-01-29T02:43:30.000Z',
        'source_files': [{'name': '/home/cedx/coveralls.php'}]
      });

      expect(job, new isInstanceOf<Job>());
      expect(job.isParallel, isTrue);
      expect(job.repoToken, equals('yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt'));

      expect(job.git, new isInstanceOf<GitData>());
      expect(job.git.branch, equals('develop'));

      expect(job.runAt, new isInstanceOf<DateTime>());
      expect(job.runAt.toIso8601String(), equals('2017-01-29T02:43:30.000Z'));

      expect(job.sourceFiles, allOf(isList, hasLength(1)));
      expect(job.sourceFiles[0], new isInstanceOf<SourceFile>());
      expect(job.sourceFiles[0].name, equals('/home/cedx/coveralls.php'));
    });
  });

  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      var map = new Job().toJson();
      expect(map, allOf(isMap, hasLength(1)));
      expect(map['source_files'], allOf(isList, isEmpty));
    });

    test('should return a non-empty map for an initialized instance', () {
      var job = new Job()
        ..git = new GitData(null, 'develop')
        ..isParallel = true
        ..repoToken = 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt'
        ..runAt = DateTime.parse('2017-01-29T02:43:30.000Z')
        ..sourceFiles.add(new SourceFile('/home/cedx/coveralls.php'));

      var map = job.toJson();
      expect(map, allOf(isMap, hasLength(5)));
      expect(map['parallel'], isTrue);
      expect(map['repo_token'], equals('yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt'));
      expect(map['run_at'], equals('2017-01-29T02:43:30.000Z'));

      expect(map['git'], isMap);
      expect(map['git']['branch'], equals('develop'));

      expect(map['source_files'], allOf(isList, hasLength(1)));
      expect(map['source_files'][0], isMap);
      expect(map['source_files'][0]['name'], equals('/home/cedx/coveralls.php'));
    });
  });
});
