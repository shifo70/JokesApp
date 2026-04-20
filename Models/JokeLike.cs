namespace JokesApp.Models
{
    public class JokeLike
    {
        public int Id { get; set; }
        public int JokeId { get; set; }
        public string UserId { get; set; }

        public Joke Joke { get; set; }
    }
}