# Command line interface
The easy way. From a command prompt, install the `coveralls` executable:

```shell
dart pub global activate coveralls
```

?> Consider adding the `dart pub global` executables directory to your system path.

Then use it to upload your coverage reports:

```shell
$ coveralls --help

Send a coverage report to the Coveralls service.

Usage: coveralls [options] <file>

Options:
-h, --help       Output usage information.
-v, --version    Output the version number.
```

For example:

```shell
coveralls build/lcov.info
```
