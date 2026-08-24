class CreateAnalyses < ActiveRecord::Migration[8.1]
  def change
    create_table :analyses do |t|
      t.text :sql_query
      t.string :db_type
      t.text :explanation
      t.text :performance_issues
      t.text :security_issues
      t.text :index_recommendations
      t.text :optimized_query
      t.text :optimization_reason

      t.timestamps
    end
  end
end
