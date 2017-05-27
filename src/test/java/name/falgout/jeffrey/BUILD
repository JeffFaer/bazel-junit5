load("//builddefs/test/java/junit:junit5.bzl", "junit5_test_library", "junit5_test_suite", "junit5_test_suites")

junit5_test_library(
    srcs = glob(["*.java"]),
    deps = [
        "//src/main/java/name/falgout/jeffrey/testing/junit5:annotations",
    ],
)

junit5_test_suites(
    exclude_tags = ["extra"],
    deps = [":junit5_tests"],
)

junit5_test_suite(
    size = "small",
    tags = ["extra"],
    deps = [":junit5_tests"],
)
