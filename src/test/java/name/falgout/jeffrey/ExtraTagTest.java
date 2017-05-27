package name.falgout.jeffrey;

import name.falgout.jeffrey.testing.junit5.SmallTest;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

@SmallTest
@Tag("extra")
public class ExtraTagTest {
  @Test
  public void pass() {}
}
