// Sample adopted from https://opentelemetry.io/docs/languages/dotnet/getting-started

using System.Globalization;
using System.Text.Json;
using Microsoft.Extensions.Logging;
// Import the namespace required for the AddGoogleCloudConsole extension method
using Google.Cloud.Logging.Console;
using helloworld_csharp.Models;

var builder = WebApplication.CreateBuilder(args);

var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";
var url = $"http://0.0.0.0:{port}";

// To output logs in Google expected way and log-trace correlation
builder.Logging.AddGoogleCloudConsole(options =>
{
    options.IncludeScopes = true;
    options.TraceGoogleCloudProjectId = builder.Configuration["TraceGoogleCloudProjectId"];
});

var app = builder.Build();

var logger = app.Logger;

int RollDice()
{
    return Random.Shared.Next(1, 7);
}

string HandleRollDice(string? player)
{
    var result = RollDice();

    if (string.IsNullOrEmpty(player))
    {
        logger.LogInformation("Anonymous player is rolling the dice: {result}", result);
    }
    else
    {
        logger.LogInformation("{player} is rolling the dice: {result}", player, result);
    }

    // Create an object to showcase structured JSON logging.
    var playerPerson = new Person
    {
        Name = "John Doe",
        Age = 30,
        Courses = ["Math", "Science"]
    };

    // Structured logging complex types
    logger.LogWithJsonPayload(LogLevel.Information, "Json Object Logging: Player information ", playerPerson);

    return result.ToString(CultureInfo.InvariantCulture);
}

app.MapGet("/rolldice/{player?}", HandleRollDice);

app.Run(url);

// Define extension methods for structured logging
internal static class LoggerExtensions
{
    // Update this method as per required business logic.
    public static void LogWithJsonPayload<T>(this ILogger logger, LogLevel logLevel, string message, T payloadObject) where T : class
    {
        // 1. Serialize the object to a JSON string
        var jsonString = JsonSerializer.Serialize(payloadObject);

        // 2. Deserialize the string into a dictionary
        // This is a robust way to convert any object into a dictionary of its public properties.
        var dictionary = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonString);

        if (dictionary is null)
        {
            // Fallback for safety
            logger.Log(logLevel, "{Message} with non-serializable payload: {@Payload}", message, payloadObject);
            return;
        }

        // 3. Begin a scope with the dictionary. The Google logger will expand this into the jsonPayload.
        using (logger.BeginScope(dictionary))
        {
            // 4. Log the simple message. The scope data will be attached automatically.
            logger.Log(logLevel, message);
        }
    }
}