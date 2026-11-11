# SmallPonyKing

### AI · Agents · Software Engineering

I build software that turns repetitive research and review into practical workflows. My current projects combine Python, language models, durable data pipelines, and simple web interfaces.

I'm interested in agents that use tools, keep useful state, and produce results people can inspect.

## Selected projects

### [Job Scraper Agent](https://github.com/SmallPonyKing/Job-Scraper-Agent)

A career research tool that gathers public job listings, enriches them with Ollama, and matches opportunities to saved role groups.

- Source adapters for shared hiring platforms and company career pages.
- Persistent SQLite queues with cancellation, retries, and resumable scans.
- Separate network and model workers, with a browser interface for reviewing results.

**Built with:** Python, SQLite, Ollama, JavaScript, HTML, CSS.

### [Mail Check Agent · BidderCheck](https://github.com/SmallPonyKing/Mail-check-agent)

A local application that compares reported job applications with confirmation emails and submission pages.

- Evidence matching with optional language model assistance.
- Gmail and Microsoft mailbox integrations.
- Reviewable results, saved audit history, and CSV/PDF reports.

**Built with:** Python, SQLite, IMAP, Microsoft OAuth, Ollama, JavaScript.

## What I'm exploring

- **Agent workflows:** tool use, persistent state, and human review.
- **Applied AI:** structured model output, validation, and useful fallbacks.
- **Software engineering:** clear module boundaries, automated tests, and recoverable background work.

## How I approach building

Keep the interface simple. Make decisions traceable. Test failure paths as well as successful ones. Use AI where it helps, and keep important behavior explicit in code.

---

Explore the repositories above for implementation details, tests, and ongoing work. For project questions or suggestions, open an issue in the relevant repository.
