namespace helloworld_csharp.Models;

public class Person
{
    public required string Name { get; set; }
    public int Age { get; set; }
    public List<string>? Courses { get; set; }
}