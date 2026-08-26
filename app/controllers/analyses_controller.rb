class AnalysesController < ApplicationController
  DB_TYPES = %w[PostgreSQL MySQL SQLite Oracle SQL\ Server MariaDB].freeze

  def new
    @analysis = Analysis.new
    @db_types = DB_TYPES
    @sample_queries = Analysis::SAMPLE_QUERIES
  end

  def create
    @db_types = DB_TYPES
    @sample_queries = Analysis::SAMPLE_QUERIES
    sql_query = params[:sql_query].to_s.strip
    db_type = params[:db_type].to_s.strip

    if sql_query.blank?
      flash.now[:alert] = "Please enter a SQL query."
      @analysis = Analysis.new
      return render :new, status: :unprocessable_entity
    end

    api_key = openai_api_key
    if api_key.blank?
      flash.now[:alert] = "OpenAI API key is not configured. Set OPENAI_API_KEY or add openai_api_key via: rails credentials:edit"
      @analysis = Analysis.new
      return render :new, status: :unprocessable_entity
    end

    begin
      service = AiAnalysisService.new(api_key)
      result = service.analyze(sql_query, db_type)

      @analysis = Analysis.create!(
        sql_query: sql_query,
        db_type: db_type,
        explanation: result["explanation"],
        performance_issues: result["performance_issues"],
        security_issues: result["security_issues"],
        index_recommendations: result["index_recommendations"],
        optimized_query: result["optimized_query"],
        optimization_reason: result["optimization_reason"],
        risk_score: Analysis.normalize_risk_score(result["risk_score"])
      )

      redirect_to @analysis
    rescue => e
      flash.now[:alert] = "Analysis failed: #{e.message}"
      @analysis = Analysis.new(sql_query: sql_query, db_type: db_type)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @analysis = Analysis.find(params[:id])
  end

  def index
    @analyses = Analysis.order(created_at: :desc).limit(20)
  end

  def destroy
    analysis = Analysis.find(params[:id])
    analysis.destroy!
    redirect_to analyses_path, notice: "Analysis deleted."
  end

  private

  def openai_api_key
    ENV["OPENAI_API_KEY"].presence ||
      Rails.application.credentials.openai_api_key
  end
end
