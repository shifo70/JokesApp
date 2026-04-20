using Microsoft.AspNetCore.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using JokesApp.Data;
using JokesApp.Models;

namespace JokesApp.Controllers
{
    public class JokesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public JokesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Jokes
        public async Task<IActionResult> Index()
        {
            return View(await _context.Joke.ToListAsync());
        }

        // GET: Jokes/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null) return NotFound();

            var joke = await _context.Joke
                .Include(j => j.Comments) 
                .FirstOrDefaultAsync(m => m.Id == id);

            if (joke == null) return NotFound();

            return View(joke);
        }

        // GET: Jokes/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Jokes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,JokesQuestion,JokesAnswer,Likes")] Joke joke)
        {
            if (ModelState.IsValid)
            {
                _context.Add(joke);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(joke);
        }

        // GET: Jokes/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var joke = await _context.Joke.FindAsync(id);
            if (joke == null)
            {
                return NotFound();
            }
            return View(joke);
        }

        // POST: Jokes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,JokesQuestion,JokesAnswer,Likes")] Joke joke)
        {
            if (id != joke.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(joke);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!JokeExists(joke.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(joke);
        }

        // GET: Jokes/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var joke = await _context.Joke
                .FirstOrDefaultAsync(m => m.Id == id);
            if (joke == null)
            {
                return NotFound();
            }

            return View(joke);
        }

        // POST: Jokes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var joke = await _context.Joke.FindAsync(id);
            if (joke != null)
            {
                _context.Joke.Remove(joke);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool JokeExists(int id)
        {
            return _context.Joke.Any(e => e.Id == id);
        }
        // --- 1. SEARCH FUNCTION ---
        public async Task<IActionResult> ShowSearchResults(string SearchPhrase)
        {
            if (string.IsNullOrEmpty(SearchPhrase)) return View("Index", await _context.Joke.ToListAsync());

            return View("Index", await _context.Joke.Where(j => j.JokesQuestion.Contains(SearchPhrase) || j.JokesAnswer.Contains(SearchPhrase)).ToListAsync());
        }

        // --- 2. ADD COMMENT FUNCTION ---
        [Authorize]
        [HttpPost]
        public async Task<IActionResult> AddComment(int JokeId, string Text)
        {
            if (!string.IsNullOrEmpty(Text))
            {
                var comment = new JokesApp.Models.Comment
                {
                    JokeId = JokeId,
                    Text = Text,
                    UserEmail = User.Identity?.Name
                };
                _context.Add(comment);
                await _context.SaveChangesAsync();
            }
            return RedirectToAction(nameof(Details), new { id = JokeId });
        }

        // --- 3. LIKE / UNLIKE FUNCTION ---
        [Authorize]
        public async Task<IActionResult> Like(int? id)
        {
            if (id == null) return NotFound();

            var joke = await _context.Joke.FindAsync(id);
            if (joke == null) return NotFound();

            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            var existingLike = await _context.Set<JokesApp.Models.JokeLike>().FirstOrDefaultAsync(l => l.JokeId == id && l.UserId == userId);

            if (existingLike == null)
            {
                var newLike = new JokesApp.Models.JokeLike { JokeId = joke.Id, UserId = userId };
                _context.Add(newLike);
                joke.Likes += 1;
            }
            else
            {
                _context.Remove(existingLike);
                joke.Likes -= 1;
            }

            _context.Update(joke);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }
    }
}
