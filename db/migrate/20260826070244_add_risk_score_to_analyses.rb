class AddRiskScoreToAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :analyses, :risk_score, :string
  end
end
