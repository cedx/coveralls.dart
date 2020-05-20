import "dart:io";
import "package:coveralls/src/io/parsers/clover.dart";
import "package:path/path.dart" as p;
import "package:test/test.dart";

/// Tests the features of the Clover parser.
void main() => group("Clover", () {
	group("parseReport()", () {
		test("should properly parse Clover reports", () async {
			final job = await parseReport(await File("test/fixtures/clover.xml").readAsString());
			expect(job.sourceFiles, hasLength(3));

			expect(job.sourceFiles.first.name, p.join("lib", "src", "io", "client.dart"));
			expect(job.sourceFiles.first.sourceDigest, isNotEmpty);
			expect(job.sourceFiles.first.coverage, containsAllInOrder([null, 2, 2, 2, 2, null]));

			expect(job.sourceFiles[1].name, p.join("lib", "src", "io", "configuration.dart"));
			expect(job.sourceFiles[1].sourceDigest, isNotEmpty);
			expect(job.sourceFiles[1].coverage, containsAllInOrder([null, 4, 4, 2, 2, 4, 2, 2, 4, 4, null]));

			expect(job.sourceFiles[2].name, p.join("lib", "src", "io", "git.dart"));
			expect(job.sourceFiles[2].sourceDigest, isNotEmpty);
			expect(job.sourceFiles[2].coverage, containsAllInOrder([null, 2, 2, 2, 2, 2, 0, 0, 2, 2, null]));
		});

		test("should throw an excepton if the Clover report is invalid", () {
			expect(parseReport("<coverage><foo /></coverage>"), throwsFormatException);
		});
	});
});
