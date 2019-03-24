@TestOn('vm')
import 'package:coveralls/coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the [SourceFile] class.
void main() => group('SourceFile', () {
  group('.fromJson()', () {
    test('should return an instance with default values for an empty map', () {
      final file = SourceFile.fromJson({});
      expect(file.coverage, isEmpty);
      expect(file.name, isEmpty);
      expect(file.source, isNull);
      expect(file.sourceDigest, isEmpty);
    });

    test('should return an initialized instance for a non-empty map', () {
      final file = SourceFile.fromJson({
        'coverage': [null, 2, 0, null, 4, 15, null],
        'name': 'coveralls.dart',
        'source': 'void main() {}',
        'source_digest': '27f5ebf0f8c559b2af9419d190299a5e'
      });

      expect(file.coverage, hasLength(7));
      expect(file.coverage.first, isNull);
      expect(file.coverage[1], 2);
      expect(file.name, 'coveralls.dart');
      expect(file.source, 'void main() {}');
      expect(file.sourceDigest, '27f5ebf0f8c559b2af9419d190299a5e');
    });
  });

  group('.toJson()', () {
    test('should return a map with default values for a newly created instance', () {
      final map = SourceFile('', '').toJson();
      expect(map, hasLength(3));
      expect(map['coverage'], allOf(isList, isEmpty));
      expect(map['name'], isEmpty);
      expect(map['source_digest'], isEmpty);
    });

    test('should return a non-empty map for an initialized instance', () {
      final map = SourceFile('coveralls.dart', '27f5ebf0f8c559b2af9419d190299a5e',
        coverage: [null, 2, 0, null, 4, 15, null],
        source: 'void main() {}'
      ).toJson();

      expect(map, hasLength(4));
      expect(map['coverage'], allOf(isList, hasLength(7)));
      expect(map['coverage'].first, isNull);
      expect(map['coverage'][1], 2);
      expect(map['name'], 'coveralls.dart');
      expect(map['source'], 'void main() {}');
      expect(map['source_digest'], '27f5ebf0f8c559b2af9419d190299a5e');
    });
  });
});
