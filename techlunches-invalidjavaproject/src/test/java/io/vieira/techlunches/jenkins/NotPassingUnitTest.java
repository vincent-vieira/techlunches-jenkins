package io.vieira.techlunches.jenkins;

import org.junit.Assert;
import org.junit.Test;

/**
 * Basic unit test not passing all assertions.
 *
 * @author <a href="mailto:vincent.vieira@supinfo.com">Vincent Vieira</a>
 */
public class NotPassingUnitTest {

    @Test
    public void notPassingTest() throws Exception {
        Assert.assertEquals("That was at this moment Jackson knew... He fucked up.", 0, 1);
    }
}
