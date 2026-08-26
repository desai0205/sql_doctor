# SQLDoctor

An AI-powered SQL query analyzer built with Ruby on Rails 8.

Paste a SQL query, pick the database type, and SQLDoctor returns:
- **Explanation** — what the query does in plain English
- **Performance Issues** — slow patterns, missing joins, full table scans
- **Security Issues** — SQL injection risks, privilege problems
- **Index Recommendations** — specific `CREATE INDEX` statements
- **Optimized Query** — a rewritten, faster version
- **Optimization Reason** — why the new version is better
- **Risk Score** — overall `High` / `Medium` / `Low` risk badge

Also included:
- **Sample queries** — one-click examples (bad/good patterns) to try
- **History** — browse past analyses and delete ones you don’t need

---

## Requirements

- Ruby 3.3+
- Rails 8.1+
- SQLite3
- An OpenAI API key ([platform.openai.com](https://platform.openai.com))

---

## Setup

### 1. Install dependencies

```bash
bundle install
```

### 2. Add your OpenAI API key

Either export it in the shell:

```bash
export OPENAI_API_KEY=sk-your-key-here
```

Or store it in Rails credentials:

```bash
EDITOR=nano bin/rails credentials:edit
```

Add this inside the file:

```yaml
openai_api_key: sk-your-key-here
```

Save and close.

### 3. Set up the database

```bash
bin/rails db:migrate
```

### 4. Start the server

```bash
ASDF_RUBY_VERSION=3.3.1 bin/rails server
```

Open [http://localhost:3000](http://localhost:3000)

---

## Usage

1. Optionally pick a **Sample Query** from the dropdown (fills SQL + database type)
2. Or paste your own SQL and select the database type (PostgreSQL, MySQL, etc.)
3. Click **Analyze Query**
4. View the full AI analysis, including the risk badge
5. Open **History** to revisit past results or delete them

---

## Project Structure

```
app/
  controllers/
    analyses_controller.rb   # new / create / show / index / destroy
  models/
    analysis.rb              # ActiveRecord model + sample queries
  services/
    ai_analysis_service.rb   # OpenAI API wrapper
  helpers/
    application_helper.rb    # risk badge helper
  views/
    analyses/
      new.html.erb           # Query input form + samples
      show.html.erb          # Analysis results + risk + delete
      index.html.erb         # History list + delete
    layouts/
      application.html.erb   # App shell
  assets/
    stylesheets/
      application.css        # All styles (dark theme)
```
