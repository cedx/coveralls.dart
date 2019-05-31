# Features

## Coverage formats
Currently, this package supports two formats of coverage reports:

- [LCOV](http://ltp.sourceforge.net/coverage/lcov.php): the de facto standard.
- [Clover](https://www.atlassian.com/software/clover): a common format produced by [Java](https://www.java.com) and [PHP](https://secure.php.net) test frameworks.

## CI services
This project has been tested with [Travis CI](https://travis-ci.com) service, but these services should also work with no extra effort:

- [AppVeyor](https://www.appveyor.com)
- [CircleCI](https://circleci.com)
- [Codeship](https://codeship.com)
- [GitLab CI](https://gitlab.com)
- [Jenkins](https://jenkins.io)
- [Semaphore](https://semaphoreci.com)
- [Solano CI](https://ci.solanolabs.com)
- [Surf](https://github.com/surf-build/surf)
- [Wercker](https://app.wercker.com)

## Environment variables
If your build system is not supported, you can still use this package.
There are a few environment variables that are necessary for supporting your build system:

- `COVERALLS_SERVICE_NAME` : the name of your build system.
- `COVERALLS_REPO_TOKEN` : the secret repository token from [Coveralls](https://coveralls.io).

There are optional environment variables:

- `COVERALLS_SERVICE_JOB_ID` : a string that uniquely identifies the build job.
- `COVERALLS_RUN_AT` : a date string for the time that the job ran. This defaults to your build system's date/time if you don't set it.

The full list of supported environment variables is available in the source code of the `Configuration` class (see the `fromEnvironment()` static method).

## The `.coveralls.yml` file
This package supports the same configuration sources as the [Coveralls](https://coveralls.io) ones:  
[Coveralls currently supports](http://docs.coveralls.io/supported-ci-services)
