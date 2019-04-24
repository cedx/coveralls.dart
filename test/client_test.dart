import 'package:coveralls/coveralls.dart';
import 'package:test/test.dart';

/// Tests the features of the [Client] class.
void main() => group('Client', () {
  group('.upload()', () {
    test('should throw an exception with an empty coverage report', () {
      expect(Client().upload(''), throwsFormatException);
    });

    test('should throw an exception with an invalid coverage report', () {
      expect(Client().upload('end_of_record'), throwsFormatException);
    });
  });

  group('.uploadJob()', () {
    test('should throw an exception with an empty coverage job', () {
      expect(Client().uploadJob(Job()), throwsArgumentError);
    });
  });
});
