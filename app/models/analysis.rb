class Analysis < ApplicationRecord
  RISK_SCORES = %w[High Medium Low].freeze

  SAMPLE_QUERIES = [
    {
      label: "Bad — SELECT * with no filter (perf)",
      db_type: "PostgreSQL",
      sql: <<~SQL.chomp
        SELECT *
        FROM orders
        ORDER BY created_at DESC;
      SQL
    },
    {
      label: "Bad — SQL injection risk (security)",
      db_type: "MySQL",
      sql: <<~SQL.chomp
        SELECT * FROM users
        WHERE email = '" + user_input + "'
        AND password = '" + password + "';
      SQL
    },
    {
      label: "Bad — N+1 style correlated subquery",
      db_type: "PostgreSQL",
      sql: <<~SQL.chomp
        SELECT u.id, u.name,
          (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.id) AS order_count
        FROM users u
        WHERE u.status = 'active';
      SQL
    },
    {
      label: "Good — indexed join with filters",
      db_type: "PostgreSQL",
      sql: <<~SQL.chomp
        SELECT u.id, u.name, COUNT(o.id) AS order_count
        FROM users u
        INNER JOIN orders o ON o.user_id = u.id
        WHERE u.created_at >= '2024-01-01'
          AND o.status = 'paid'
        GROUP BY u.id, u.name
        ORDER BY order_count DESC
        LIMIT 50;
      SQL
    }
  ].freeze

  def self.normalize_risk_score(value)
    score = value.to_s.strip.capitalize
    RISK_SCORES.include?(score) ? score : "Medium"
  end
end
