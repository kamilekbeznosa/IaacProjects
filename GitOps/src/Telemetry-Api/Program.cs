using OpenTelemetry.Metrics;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenTelemetry()
    .WithMetrics(metrics =>
    {
        metrics.AddAspNetCoreInstrumentation(); 
        metrics.AddPrometheusExporter();        
    });

var app = builder.Build();

app.MapPrometheusScrapingEndpoint();

app.MapGet("/", () => MessageHelper.GetWelcomeMessage());

app.Run();
public static class MessageHelper
{
    public static string GetWelcomeMessage() => "Telemetry API is running!";
}