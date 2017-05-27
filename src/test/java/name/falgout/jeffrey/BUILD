load(
    "//builddefs/test/java/junit:junit5.bzl",
    "junit5_test_library",
    "junit5_test",
    "junit5_test_suite",
    "junit5_test_suites",
)

# Generates exactly EverySingleTest since we specified name instead of base_name.
junit5_test_suite(
    name = "EverySingleTest",
    size = "all",
    srcs = glob(["*.java"]),
    deps = [
        "//src/main/java/name/falgout/jeffrey/testing/junit5:annotations",
    ],
)

# Generates Methods-extra.
junit5_test(
    srcs = [
        "NotATest.java",  # Ignored by JUnit 5.
        "TaggedMethodTest.java",
    ],
    base_name = "Methods",
    exclude_tags = ["extra"],
    deps = [
        "//src/main/java/name/falgout/jeffrey/testing/junit5:annotations",
    ],
)

# Generates Methods+extra.
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

junit5_test_library(
    name = "junit5_tests",
    srcs = glob(["*.java"]),
    deps = [
        "//src/main/java/name/falgout/jeffrey/testing/junit5:annotations",
    ],
)

# Generates UnlablledTests-extra, SmallTests-extra, MediumTests-extra, LargeTests-extra,
# EnormousTests-extra
junit5_test_suites(
    exclude_tags = ["extra"],
    runtime_deps = [":junit5_tests"],
)

# Generates SmallTests+extra
junit5_test_suite(
    size = "small",
    tags = ["extra"],
    runtime_deps = [":junit5_tests"],
)
