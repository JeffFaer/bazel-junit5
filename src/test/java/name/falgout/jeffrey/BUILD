load(
    "//builddefs/test/java/junit:junit5.bzl",
    "junit5_test_library",
    "junit5_test",
    "junit5_test_suite",
    "junit5_test_suites",
)

junit5_test_library(
    name = "junit5_tests",
    srcs = glob(["*.java"]),
    deps = [
        "//src/main/java/name/falgout/jeffrey/testing/junit5:annotations",
    ],
)

junit5_test(
    srcs = [
        "TaggedMethodTest.java",
    ],
    base_name = "Methods",
    exclude_tags = ["extra"],
    deps = [
        "//src/main/java/name/falgout/jeffrey/testing/junit5:annotations",
    ],
)

junit5_test(
    srcs = [
        "TaggedMethodTest.java",
    ],
    base_name = "Methods",
    tags = ["extra"],
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
