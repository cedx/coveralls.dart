import 'package:coveralls/coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the [Configuration] class.
void main() => group('Configuration', () {
  group('.keys', () {
    test('should return an empty array for an empty configuration', () {
      expect(Configuration().keys, isEmpty);
    });

    test('should return the list of keys for a non-empty configuration', () {
      final keys = Configuration({'foo': 'bar', 'baz': 'qux'}).keys.toList();
      expect(keys, hasLength(2));
      expect(keys.first, 'foo');
      expect(keys.last, 'baz');
    });
  });

  group('operator []', () {
    test('should properly get and set the configuration entries', () {
      final configuration = Configuration();
      expect(configuration['foo'], isNull);

      configuration['foo'] = 'bar';
      expect(configuration['foo'], 'bar');
    });
  });

  group('.clear()', () {
    test('should be empty when there is no CI environment variables', () {
      final configuration = Configuration({'foo': 'bar', 'baz': 'qux'});
      expect(configuration, hasLength(2));
      configuration.clear();
      expect(configuration, hasLength(0));
    });
  });

  group('.fromEnvironment()', () {
    test('should return an empty configuration for an empty environment', () async {
      expect(await Configuration.fromEnvironment({}), isEmpty);
    });

    test('should return an initialized instance for a non-empty environment', () async {
      final configuration = await Configuration.fromEnvironment({
        'CI_NAME': 'travis-pro',
        'CI_PULL_REQUEST': 'PR #123',
        'COVERALLS_REPO_TOKEN': '0123456789abcdef',
        'GIT_MESSAGE': 'Hello World!',
        'TRAVIS': 'true',
        'TRAVIS_BRANCH': 'develop'
      });

      expect(configuration['commit_sha'], isNull);
      expect(configuration['git_message'], 'Hello World!');
      expect(configuration['repo_token'], '0123456789abcdef');
      expect(configuration['service_branch'], 'develop');
      expect(configuration['service_name'], 'travis-pro');
      expect(configuration['service_pull_request'], '123');
    });
  });

  group('.fromYaml()', () {
    test('should throw an exception with a non-object value', () {
      expect(() => Configuration.fromYaml('**123/456**'), throwsFormatException);
      expect(() => Configuration.fromYaml('foo'), throwsFormatException);
    });

    test('should return an initialized instance for a non-empty map', () {
      final configuration = Configuration.fromYaml('repo_token: 0123456789abcdef\nservice_name: travis-ci');
      expect(configuration, hasLength(2));
      expect(configuration['repo_token'], '0123456789abcdef');
      expect(configuration['service_name'], 'travis-ci');
    });
  });

  group('.loadDefaults()', () {
    test('should properly initialize from a `.coveralls.yml` file', () async {
      final configuration = await Configuration.loadDefaults('test/fixtures/.coveralls.yml');
      expect(configuration.length, greaterThanOrEqualTo(2));
      expect(configuration['repo_token'], 'yYPv4mMlfjKgUK0rJPgN0AwNXhfzXpVwt');
      expect(configuration['service_name'], 'travis-pro');
    });

    test('should use the environment defaults if the `.coveralls.yml` file is not found', () async {
      final configuration = await Configuration.loadDefaults('.dummy/config.yml');
      final defaults = await Configuration.fromEnvironment();
      expect(configuration.length, defaults.length);
      for (final key in configuration.keys) expect(configuration[key], defaults[key]);
    });
  });

  group('.merge()', () {
    test('should have the same entries as the other configuration', () {
      final configuration = Configuration();
      expect(configuration, isEmpty);

      configuration.merge(Configuration({'foo': 'bar', 'bar': 'baz'}));
      expect(configuration, hasLength(2));
      expect(configuration['foo'], 'bar');
      expect(configuration['bar'], 'baz');
    });
  });

  group('.remove()', () {
    test('should be empty when there is no CI environment variables', () {
      final configuration = Configuration({'foo': 'bar', 'bar': 'baz'});
      expect(configuration, contains('foo'));
      configuration.remove('foo');
      expect(configuration, isNot(contains('foo')));
    });
  });
});
