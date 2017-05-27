# bazel-junit5
JUnit 5 build and test targets for bazel

## How can I include this in my project?
Put the following on your WORKSPACE
````bzl
git_repository(
    name = "name_falgout_jeffrey_junit5",
    remote = "https://github.com/JeffreyFalgout/bazel-junit5.git",
    tag = "v0.2.0",
)

load("@name_falgout_jeffrey_junit5//java:junit5.bzl", "junit5_dependencies", etc)

# If you want to depend on the annotations as //external:junit5-annotations
bind(
    name = "junit5-annotations",
    actual = "@name_falgout_jeffrey_junit5//src/main/java/name/falgout/jeffrey/testing/junit5:annotations",
)
````
