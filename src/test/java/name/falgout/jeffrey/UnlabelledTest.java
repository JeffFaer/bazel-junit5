package name.falgout.jeffrey;

import static org.junit.jupiter.api.Assertions.fail;

import org.junit.jupiter.api.Test;

public class UnlabelledTest {
  @Test
  public void thisTestShouldPass() {}

  @Test
  public void thisTestShouldFail() {
    fail("Expected to fail.");
  }
}