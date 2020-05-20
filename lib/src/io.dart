/// Provides the I/O support.
library coveralls.io;

import "dart:async";
import "dart:collection";
import "dart:convert";
import "dart:io";
import "package:http/http.dart" as http;
import "package:json_annotation/json_annotation.dart";
import "package:where/where.dart";
import "package:yaml/yaml.dart";

import "io/parsers/clover.dart" deferred as clover;
import "io/parsers/lcov.dart" deferred as lcov;
import "io/services/appveyor.dart" deferred as appveyor;
import "io/services/circleci.dart" deferred as circleci;
import "io/services/codeship.dart" deferred as codeship;
import "io/services/github.dart" deferred as github;
import "io/services/gitlab_ci.dart" deferred as gitlab_ci;
import "io/services/jenkins.dart" deferred as jenkins;
import "io/services/semaphore.dart" deferred as semaphore;
import "io/services/solano_ci.dart" deferred as solano_ci;
import "io/services/surf.dart" deferred as surf;
import "io/services/travis_ci.dart" deferred as travis_ci;
import "io/services/wercker.dart" deferred as wercker;

part "io.g.dart";
part "io/client.dart";
part "io/configuration.dart";
part "io/git.dart";
part "io/job.dart";
part "io/source_file.dart";
