import "../../io.dart";

/// Gets the [Travis CI](https://travis-ci.com) configuration parameters from the specified environment.
Configuration getConfiguration(Map<String, String> env) {
	final config = Configuration({
		"commit_sha": env["TRAVIS_COMMIT"],
		"flag_name": env["TRAVIS_JOB_NAME"],
		"service_branch": env["TRAVIS_BRANCH"],
		"service_build_url": env["TRAVIS_BUILD_WEB_URL"],
		"service_job_id": env["TRAVIS_JOB_ID"],
		"service_name": "travis-ci"
	});

	if (env.containsKey("TRAVIS_PULL_REQUEST") && env["TRAVIS_PULL_REQUEST"] != "false")
		config["service_pull_request"] = env["TRAVIS_PULL_REQUEST"];

	return config;
}
