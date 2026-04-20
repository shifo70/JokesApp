using System.Collections.Generic;

namespace JokesApp.Models
{
    public class Joke
    {
        public int Id { get; set; }
        public string JokesQuestion { get; set; }
        public string JokesAnswer { get; set; }
        public int Likes { get; set; }

        public List<Comment> Comments { get; set; } = new List<Comment>();
        public List<JokeLike> JokeLikes { get; set; } = new List<JokeLike>();
    }
}