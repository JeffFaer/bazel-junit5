package(default_visibility = ["//:internal"])

load("//java:junit5.bzl", "junit5_java_libraries")

junit5_java_libraries(
    testonly = 1,
    artifacts = [
        "api",
        "engine",
    ],
    component = "jupiter",
)

junit5_java_libraries(
    testonly = 1,
    artifacts = [
        "commons",
        "console",
        "engine",
        "launcher",
    ],
    component = "platform",
)

java_library(
    name = "opentest4j",
    testonly = 1,
    exports = [
        "@org_opentest4j_opentest4j//jar",
    ],
)
