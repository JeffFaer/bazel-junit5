# bazel-junit5
JUnit 5 build and test targets for bazel

## How can I include this in my project?
Put the following on your WORKSPACE
````bzl
git_repository(
    name = "bazel_junit5",
    remote = "https://github.com/JeffreyFalgout/bazel-junit5.git",
    tag = "v0.1.0",
)

# Now you can use things like
load("@bazel_junit5//builddefs/test/java/junit:junit5.bzl", "junit5_dependencies", etc)
````
