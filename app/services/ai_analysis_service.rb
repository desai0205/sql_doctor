class AiAnalysisService
  include HTTParty
  base_uri "https://api.openai.com"

  MODEL = "gpt-4o-mini"

  SYSTEM_PROMPT = <<~PROMPT
    You are an expert SQL database engineer and security analyst.
    Analyze the given SQL query and respond with a JSON object containing exactly these keys:
    - explanation: A clear, concise explanation of what the query does (2-4 sentences).
    - performance_issues: Bullet-point list of performance problems found. If none, say "No major performance issues found."
    - security_issues: Bullet-point list of security vulnerabilities (e.g. SQL injection risk, privilege escalation). If none, say "No security issues found."
    - index_recommendations: Specific index recommendations (e.g. "CREATE INDEX idx_users_email ON users(email);"). If none, say "No index recommendations."
    - optimized_query: The rewritten, optimized version of the SQL query. Keep the same logic but improve performance.
    - optimization_reason: A short explanation (1-3 sentences) of what was changed and why it's better.
    Respond with only valid JSON, no markdown fences.
  PROMPT

  def initialize(api_key)
    @api_key = api_key
  end

  def analyze(sql_query, db_type)
    user_message = "Database type: #{db_type}\n\nSQL Query:\n#{sql_query}"

    response = self.class.post(
      "/v1/chat/completions",
      headers: {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type" => "application/json"
      },
      body: {
        model: MODEL,
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user", content: user_message }
        ],
        temperature: 0.2,
        response_format: { type: "json_object" }
      }.to_json,
      timeout: 60
    )

    raise "API error: #{response.code} — #{response.body}" unless response.success?

    content = response.parsed_response.dig("choices", 0, "message", "content")
    parse_json(content)
  end

  private

  def parse_json(content)
    cleaned = content.to_s.strip
    cleaned = cleaned.sub(/\A```(?:json)?\s*/i, "").sub(/```\z/, "").strip
    JSON.parse(cleaned)
  end
end
