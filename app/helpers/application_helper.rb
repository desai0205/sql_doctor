module ApplicationHelper
  def risk_badge(score)
    level = Analysis.normalize_risk_score(score)
    content_tag(:span, "#{level} risk", class: "risk-badge risk-badge--#{level.downcase}")
  end
end
