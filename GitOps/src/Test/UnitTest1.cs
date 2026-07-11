using Xunit;

namespace Test;

public class UnitTest1
{
    [Fact]
    public void WelcomeMessage_ShouldReturnCorrectString()
    {
        var message = MessageHelper.GetWelcomeMessage();

        Assert.Equal("Telemetry API is running!", message);
        Assert.NotNull(message);
    }
}