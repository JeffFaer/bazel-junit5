"""
Provides build and test targets for JUnit 5.

All of the test targets in this file support tags= and exclude_tags= parameters. These are
translated to JUnit 5 @Tag filters.

junit5_test_suite and junit5_test have the following naming convention:
    ${base_name}+${tags[0]}+${tags[1]}-${exclude_tags[0]}-${exclude_tags[1]}

This can be overridden by explicitly supplying name = "YourTestName" to the target.
"""

TEST_SIZES = [
    None,
    "small",
    "medium",
    "large",
    "enormous",
]

JUNIT5_COMPONENTS = [
    "jupiter",
    "platform",
]

JUNIT5_GROUP_IDS = {
    "jupiter": "org.junit.jupiter",
    "platform": "org.junit.platform",
}

JUNIT5_ARTIFACT_ID_PATTERNS = {
    "jupiter": "junit-jupiter-%s",
    "platform": "junit-platform-%s",
}

JUNIT5_TEST_DEPS = [
    "//external:junit5_jupiter_api",
]

JUNIT5_RUNTIME_DEPS = [
    "//external:junit5_jupiter_engine",
    "//external:junit5_platform_commons",
    "//external:junit5_platform_console",
    "//external:junit5_platform_engine",
    "//external:junit5_platform_launcher",
    "//external:opentest4j",
]

def junit5_dependencies(component, artifacts, version):
  """
  Create a dependency for each artifact. Each will be available as
  //external:junit5_${component}_${artifact}
  """
  for artifact in artifacts:
    junit5_dependency(component, artifact, version)

def junit5_dependency(component, artifact, version):
  """
  Create a dependency on a JUnit 5 maven jar. It will be available as
  //external:junit5_${component}_${artifact}
  """
  if not component in JUNIT5_COMPONENTS:
    fail("%s is not a JUnit 5 component." % component)

  groupId = JUNIT5_GROUP_IDS[component]
  artifactId = JUNIT5_ARTIFACT_ID_PATTERNS[component] % artifact
  maven_name = "%s_%s" % (groupId.replace('.', '_'), artifactId.replace('-', '_'))
  native.maven_jar(
      name = maven_name,
      artifact = "%s:%s:%s" % (groupId, artifactId, version),
  )

  native.bind(
      name = "junit5_%s_%s" % (component, artifact),
      actual = "@%s//jar" % maven_name,
  )

def junit5_test_library(name, srcs, deps=[], _junit5_test_deps=JUNIT5_TEST_DEPS, **kwargs):
  """
  Automatically adds JUnit 5 compile dependencies so you don't have to.
  """
  native.java_library(
      name = name,
      srcs = srcs,
      deps = deps + _junit5_test_deps,
      testonly = 1,
      **kwargs
  )

def junit5_test_suites(sizes=TEST_SIZES, **kwargs):
  """
  Create a test suite for the specified test sizes. Defaults to creating one test suite for every
  possible test size, including unlabelled.
  """
  for size in sizes:
    junit5_test_suite(size, **kwargs)

def junit5_test_suite(size, src_dir=None, **kwargs):
  """
  Create a test suite that will run every test of the given size that is included in this target,
  and in this package.

  If size is None, then this suite will run unlabelled tests. If size is "all", then this suite will
  run every test regardless of size.

  If a test is tagged with more than one size, it will only run with the larger size.
  """
  if size != "all" and not size in TEST_SIZES:
    fail("%s is not a valid test size." % size)

  selection_flags = [
    "--select-package %s" % __get_java_package(PACKAGE_NAME, src_dir)
  ]

  if size != "all":
    selection_flags += __get_size_flags(size)

  size_string = size or "Unlabelled"
  suite_name = size_string.capitalize() + "Tests"

  __junit5_test(
      base_name = suite_name,
      selection_flags = selection_flags,
      size = size if size != "all" else None,
      **kwargs
  )

def junit5_test(base_name, srcs, src_dir=None, **kwargs):
  """
  Run the JUnit 5 tests in srcs.
  """
  java_package = __get_java_package(PACKAGE_NAME, src_dir)
  class_names = __get_class_names(java_package, srcs)
  selection_flags = [ "--select-class %s" % class_name for class_name in class_names ]

  __junit5_test(
      base_name = base_name,
      selection_flags = selection_flags,
      srcs = srcs,
      **kwargs
  )

def __junit5_test(
    base_name,
    selection_flags,
    name=None,
    tags=[],
    exclude_tags=[],
    deps=[],
    runtime_deps=[],
    _junit5_test_deps=JUNIT5_TEST_DEPS,
    _junit5_runtime_deps=JUNIT5_RUNTIME_DEPS,
    **kwargs):
  if name == None:
    name = base_name
    for tag in sorted(tags):
      name += "+" + tag

    for tag in sorted(exclude_tags):
      name += "-" + tag

  flags = selection_flags + __get_tag_flags(tags, exclude_tags)

  native.java_test(
      name = name,
      args = flags,
      main_class = "org.junit.platform.console.ConsoleLauncher",
      use_testrunner = False,
      deps = deps + _junit5_test_deps if deps else None,
      runtime_deps = runtime_deps + _junit5_runtime_deps,
      **kwargs
  )

def __get_java_package(dir_path, src_dir):
  if src_dir == None:
    src_dirs = [ "src/main/java/", "src/test/java/", "java/", "javatests/" ]
  else:
    if not src_dir.endswith('/'):
      src_dir += '/'

    src_dirs = [ src_dir ]

  for dir in src_dirs:
    index = __prefix_index(dir_path, dir)
    if index >= 0:
      sub_path = dir_path[index:]
      return sub_path.replace('/', '.')

  fail("Could not find a src root: %s in path: %s" % (src_dirs, dir_path))

def __prefix_index(haystack, needle):
  if needle in haystack:
    return haystack.index(needle) + len(needle)
  else:
    return -1

def __get_size_flags(size):
  if size == None:
    self_flag = []
  else:
    self_flag = [ "-t %s" % size ]

  index = TEST_SIZES.index(size)
  return self_flag + [ "-T %s" % s for s in TEST_SIZES[index+1:]]

def __get_tag_flags(tags, exclude_tags):
  return [ "-t %s" % tag for tag in tags ] + [ "-T %s" % tag for tag in exclude_tags ]

def __get_class_names(java_package, srcs):
  class_names = []
  tail = ".java"
  for src in srcs:
    if not src.endswith(tail):
      continue

    stripped_src = src[:len(src) - len(tail)]
    class_names.append("%s.%s" % (java_package, stripped_src))

  return class_names