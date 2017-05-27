package name.falgout.jeffrey;

import name.falgout.jeffrey.testing.junit5.MediumTest;
import name.falgout.jeffrey.testing.junit5.SmallTest;
import org.junit.jupiter.api.Test;

@SmallTest
@MediumTest // This is picked up under MediumTests.
public class DoublyLabelledTest {
  @Test
  public void pass() {}
}
