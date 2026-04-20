using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace JokesApp.Data
{
    public class ApplicationDbContext : IdentityDbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        // الجداول الخاصة بنا
        public DbSet<JokesApp.Models.Joke> Joke { get; set; }
        public DbSet<JokesApp.Models.Comment> Comment { get; set; }
        public DbSet<JokesApp.Models.JokeLike> JokeLike { get; set; }
    }
}