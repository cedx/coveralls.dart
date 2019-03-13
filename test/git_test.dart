import 'package:coveralls/coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the Git classes.
void main() => group('GitCommit', () {
  group('GitCommit', () {
    group('.fromJson()', () {
      test('should return an instance with default values for an empty map', () {
        final commit = GitCommit.fromJson({});
        expect(commit.authorEmail, isNull);
        expect(commit.authorName, isNull);
        expect(commit.id, isNull);
        expect(commit.message, isNull);
      });

      test('should return an initialized instance for a non-empty map', () {
        final commit = GitCommit.fromJson({
          'author_email': 'anonymous@secret.com',
          'author_name': 'Anonymous',
          'id': '2ef7bde608ce5404e97d5f042f95f89f1c232871',
          'message': 'Hello World!'
        });

        expect(commit.authorEmail, 'anonymous@secret.com');
        expect(commit.authorName, 'Anonymous');
        expect(commit.id, '2ef7bde608ce5404e97d5f042f95f89f1c232871');
        expect(commit.message, 'Hello World!');
      });
    });

    group('.toJson()', () {
      test('should return a map with default values for a newly created instance', () {
        final map = const GitCommit('').toJson();
        expect(map, hasLength(1));
        expect(map['id'], isEmpty);
      });

      test('should return a non-empty map for an initialized instance', () {
        final map = const GitCommit(
          '2ef7bde608ce5404e97d5f042f95f89f1c232871',
          authorEmail: 'anonymous@secret.com',
          authorName: 'Anonymous',
          message: 'Hello World!'
        ).toJson();

        expect(map, hasLength(4));
        expect(map['author_email'], 'anonymous@secret.com');
        expect(map['author_name'], 'Anonymous');
        expect(map['id'], '2ef7bde608ce5404e97d5f042f95f89f1c232871');
        expect(map['message'], 'Hello World!');
      });
    });

    group('.toString()', () {
      final data = const GitCommit(
        '2ef7bde608ce5404e97d5f042f95f89f1c232871',
        authorEmail: 'anonymous@secret.com',
        authorName: 'Anonymous',
        message: 'Hello World!'
      ).toString();

      test('should start with the class name', () {
        expect(data.indexOf('GitCommit {'), 0);
      });

      test('should contain the instance properties', () {
        expect(data, contains('"author_email":"anonymous@secret.com"'));
        expect(data, contains('"author_name":"Anonymous"'));
        expect(data, contains('"id":"2ef7bde608ce5404e97d5f042f95f89f1c232871"'));
        expect(data, contains('"message":"Hello World!"'));
      });
    });
  });

  group('GitData', () {
    group('.fromJson()', () {
      test('should return an instance with default values for an empty map', () {
        final data = GitData.fromJson({});
        expect(data.branch, isEmpty);
        expect(data.commit, isNull);
        expect(data.remotes, isEmpty);
      });

      test('should return an initialized instance for a non-empty map', () {
        final data = GitData.fromJson({
          'branch': 'develop',
          'head': {'id': '2ef7bde608ce5404e97d5f042f95f89f1c232871'},
          'remotes': [{'name': 'origin'}]
        });

        expect(data.branch, 'develop');

        expect(data.commit, isNotNull);
        expect(data.commit.id, '2ef7bde608ce5404e97d5f042f95f89f1c232871');

        expect(data.remotes, hasLength(1));
        expect(data.remotes.first, isNotNull);
        expect(data.remotes.first.name, 'origin');
      });
    });

    group('.fromRepository()', () {
      test('should retrieve the Git data from the executable output', () async {
        final data = await GitData.fromRepository();
        expect(data.branch, isNotEmpty);

        expect(data.commit, isNotNull);
        expect(data.commit.id, matches(RegExp(r'^[a-f\d]{40}$')));

        expect(data.remotes, isNotEmpty);
        expect(data.remotes.first, isNotNull);

        final origin = data.remotes.where((remote) => remote.name == 'origin').toList();
        expect(origin, hasLength(1));
        expect(origin.first.url, anyOf(
          Uri.https('github.com', '/cedx/coveralls.dart.git'),
          Uri.parse('ssh://git@github.com/cedx/coveralls.dart.git')
        ));
      });
    });

    group('.toJson()', () {
      test('should return a map with default values for a newly created instance', () {
        final map = GitData(null).toJson();
        expect(map['branch'], isEmpty);
        expect(map['head'], isNull);
        expect(map['remotes'], allOf(isList, isEmpty));
      });

      test('should return a non-empty map for an initialized instance', () {
        final map = GitData(
          const GitCommit('2ef7bde608ce5404e97d5f042f95f89f1c232871'),
          branch: 'develop',
          remotes: [GitRemote('origin')]
        ).toJson();

        expect(map['branch'], 'develop');
        expect(map['head'], isMap);
        expect(map['head']['id'], '2ef7bde608ce5404e97d5f042f95f89f1c232871');
        expect(map['remotes'], allOf(isList, hasLength(1)));
        expect(map['remotes'].first, isMap);
        expect(map['remotes'].first['name'], 'origin');
      });
    });

    group('.toString()', () {
      final data = GitData(
        const GitCommit('2ef7bde608ce5404e97d5f042f95f89f1c232871'),
        branch: 'develop',
        remotes: [GitRemote('origin')]
      ).toString();

      test('should start with the class name', () {
        expect(data.indexOf('GitData {'), 0);
      });

      test('should contain the instance properties', () {
        expect(data, contains('"branch":"develop"'));
        expect(data, contains('"head":{'));
        expect(data, contains('"remotes":[{'));
      });
    });
  });

  group('GitRemote', () {
    group('.fromJson()', () {
      test('should return an instance with default values for an empty map', () {
        final remote = GitRemote.fromJson({});
        expect(remote.name, isEmpty);
        expect(remote.url, isNull);
      });

      test('should return an initialized instance for a non-empty map', () {
        var remote = GitRemote.fromJson({'name': 'origin', 'url': 'git@github.com:cedx/coveralls.dart.git'});
        expect(remote.name, 'origin');
        expect(remote.url, Uri.parse('ssh://git@github.com/cedx/coveralls.dart.git'));

        remote = GitRemote.fromJson({'name': 'origin', 'url': 'https://github.com/cedx/coveralls.dart.git'});
        expect(remote.url, Uri.https('github.com', '/cedx/coveralls.dart.git'));
      });
    });

    group('.toJson()', () {
      test('should return a map with default values for a newly created instance', () {
        final map = GitRemote('').toJson();
        expect(map['name'], isEmpty);
        expect(map['url'], isNull);
      });

      test('should return a non-empty map for an initialized instance', () {
        var map = GitRemote('origin', 'git@github.com:cedx/coveralls.dart.git').toJson();
        expect(map['name'], 'origin');
        expect(map['url'], 'ssh://git@github.com/cedx/coveralls.dart.git');

        map = GitRemote('origin', Uri.https('github.com', '/cedx/coveralls.dart.git')).toJson();
        expect(map['url'], 'https://github.com/cedx/coveralls.dart.git');
      });
    });

    group('.toString()', () {
      final data = GitRemote('origin', 'git@github.com:cedx/coveralls.dart.git').toString();

      test('should start with the class name', () {
        expect(data.indexOf('GitRemote {'), 0);
      });

      test('should contain the instance properties', () {
        expect(data, allOf(contains('"name":"origin"'), contains('"url":"ssh://git@github.com/cedx/coveralls.dart.git"')));

        final httpRemote = GitRemote('origin', Uri.https('github.com', '/cedx/coveralls.dart.git')).toString();
        expect(httpRemote, contains('"url":"https://github.com/cedx/coveralls.dart.git"'));
      });
    });
  });
});
