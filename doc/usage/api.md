---
path: src/branch/master
source: lib/src/io/client.dart
---

# Application programming interface
The hard way. Use the `Client` class to upload your coverage reports:

``` dart
import "dart:io";
import "package:coveralls/coveralls.dart";

Future<void> main() async {
	try {
		var coverage = File("/path/to/coverage.report");
		await Client().upload(await coverage.readAsString());
		print("The report was sent successfully.");
	}

	on Exception catch (err) {
		print("An error occurred: $err");
	}
}
```

The `Client.upload()` method returns a [`Future`](https://api.dart.dev/stable/dart-async/Future-class.html) that completes when the coverage report has been uploaded.

The future completes with a [`FormatException`](https://api.dart.dev/stable/dart-core/FormatException-class.html) if the input report is invalid.
It completes with a `ClientException` if any error occurred while uploading the report.

## Client events
The `Client` class triggers some events during its life cycle:

- `request` : emitted every time a request is made to the remote service.
- `response` : emitted every time a response is received from the remote service.

These events are exposed as [`Stream`](https://api.dart.dev/stable/dart-async/Stream-class.html), you can listen to them using the `on<EventName>` properties:

``` dart
client.onRequest.listen(
	(request) => print("Client request: ${request.url}")
);

client.onResponse.listen(
	(response) => print("Server response: ${response.statusCode}")
);
```
