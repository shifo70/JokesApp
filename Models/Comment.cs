namespace JokesApp.Models
{
    public class Comment
    {
        public int Id { get; set; }
        public string Text { get; set; }
        public string UserEmail { get; set; }
        public int JokeId { get; set; }

        public Joke Joke { get; set; }
    }
}