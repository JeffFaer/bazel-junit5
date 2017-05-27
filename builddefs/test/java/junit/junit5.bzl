TEST_SIZES = [
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

"""
Create a junit5_dependency for each artifact under the component with the given version.
"""
def junit5_dependencies(component, artifacts, version):
  for artifact in artifacts:
    junit5_dependency(component, artifact, version)

"""
Create a dependency on a JUnit5 maven jar. It will be available as
//external:junit5_component_artifact
"""
def junit5_dependency(component, artifact, version):
  if not component in JUNIT5_COMPONENTS:
    fail("%s is not a JUnit5 component." % component)

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

"""
Automatically adds JUnit5 compile dependencies so you don't have to. It name is not given, it
defaults to junit5_tests.
"""
def junit5_test_library(srcs, name=None, deps=[], _junit5_test_deps=JUNIT5_TEST_DEPS, **kwargs):
  if name == None:
    name = "junit5_tests"

  native.java_library(
      name = name,
      srcs = srcs,
      deps = deps + _junit5_test_deps,
      testonly = 1,
      **kwargs
  )

def junit5_test_suites(deps, sizes=None, **kwargs):
  if sizes == None:
    sizes = TEST_SIZES + [ None ]

  for size in sizes:
    junit5_test_suite(size, deps, **kwargs)

def junit5_test_suite(size, deps, tags=[], exclude_tags=[], src_dir=None, _junit5_runtime_deps=JUNIT5_RUNTIME_DEPS):
  if size != None and not size in TEST_SIZES:
    fail("%s is not a valid test size." % size)

  flags = [
    "--select-package %s" % __get_java_package(PACKAGE_NAME, src_dir)
  ] + __get_tag_flags(size, tags, exclude_tags)

  name = __get_suite_name(size, tags, exclude_tags)

  native.java_test(
      name = name,
      size = size,
      args = flags,
      main_class = "org.junit.platform.console.ConsoleLauncher",
      use_testrunner = False,
      runtime_deps = _junit5_runtime_deps + deps,
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
  if haystack.startswith(needle):
    return len(needle)
  else:
    return -1


def __get_tag_flags(size, tags, exclude_tags):
  return (__get_size_flags(size) +
   [ "-t %s" % tag for tag in tags ] +
   [ "-T %s" % tag for tag in exclude_tags ])

def __get_size_flags(size):
  if size == None:
    return [ "-T %s" % s for s in TEST_SIZES ]

  index = TEST_SIZES.index(size)
  return [ "-t %s" % size ] + [ "-T %s" % s for s in TEST_SIZES[index+1:]]

def __get_suite_name(size, tags, exclude_tags):
  size_string = size or "Unlabelled"
  base_name = size_string.capitalize() + "Tests"

  for tag in sorted(tags):
    base_name += "+" + tag

  for tag in sorted(exclude_tags):
    base_name += "-" + tag

  return base_name