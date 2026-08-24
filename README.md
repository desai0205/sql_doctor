# SQLDoctor

An AI-powered SQL query analyzer built with Ruby on Rails 8.

Paste a SQL query, pick the database type, and SQLDoctor returns:
- **Explanation** — what the query does in plain English
- **Performance Issues** — slow patterns, missing joins, full table scans
- **Security Issues** — SQL injection risks, privilege problems
- **Index Recommendations** — specific `CREATE INDEX` statements
- **Optimized Query** — a rewritten, faster version
- **Optimization Reason** — why the new version is better

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
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000)

---

## Usage

1. Paste your SQL query into the text area
2. Select the database type (PostgreSQL, MySQL, etc.)
3. Click **Analyze Query**
4. View the full AI analysis

Previous analyses are saved and accessible via **History**.

---

## Project Structure

```
app/
  controllers/
    analyses_controller.rb   # new / create / show / index
  models/
    analysis.rb              # ActiveRecord model
  services/
    ai_analysis_service.rb   # OpenAI API wrapper
  views/
    analyses/
      new.html.erb           # Query input form
      show.html.erb          # Analysis results
      index.html.erb         # History list
    layouts/
      application.html.erb   # App shell
  assets/
    stylesheets/
      application.css        # All styles (dark theme)
```
