package name.falgout.jeffrey;

import name.falgout.jeffrey.testing.junit5.MediumTest;
import name.falgout.jeffrey.testing.junit5.SmallTest;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

public class TaggedMethodTest {
  @Test
  @SmallTest
  public void smallMethod() {}

  @Test
  @MediumTest
  public void mediumMethod() {}

  @Test
  @Tag("extra")
  public void extraMethod() {}
}
