workspace(name = "name_falgout_jeffrey_testing_bazel_junit5")

load("//java:junit5.bzl", "junit5_dependencies")

junit5_dependencies(
    artifacts = [
        "api",
        "engine",
    ],
    component = "jupiter",
    version = "5.0.0-M4",
)

junit5_dependencies(
    artifacts = [
        "commons",
        "console",
        "engine",
        "launcher",
    ],
    component = "platform",
    version = "1.0.0-M4",
)

maven_jar(
    name = "org_opentest4j_opentest4j",
    artifact = "org.opentest4j:opentest4j:1.0.0-M2",
)

bind(
    name = "opentest4j",
    actual = "@org_opentest4j_opentest4j//jar",
)
