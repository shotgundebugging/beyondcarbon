class EmploymentController < ApplicationController
  def index
    @regions = Region.order(:code).pluck(:code)
    @stressors = EmploymentData.distinct.order(:stressor).pluck(:stressor)
    @country_names = Region.pluck(:code, :name).to_h

    @region = params[:region].presence || @regions.first
    @stressor = params[:stressor].presence || @stressors.first
    @metric = params[:metric].presence || "people" # people | share
    @topn = (params[:topn].presence || 8).to_i
    @sort = params[:sort].presence || "desc" # desc | asc | alpha

    base_scope = EmploymentData.joins(:region)
                               .where(regions: { code: @region }, stressor: @stressor)
                               .select(:sector, :value)

    raw = base_scope.map { |r| { sector: r.sector, value: r.value.to_f } }

    if @metric == "share"
      total = raw.sum { |h| h[:value] }
      raw = raw.map { |h| { sector: h[:sector], value: total.positive? ? (h[:value] / total * 100.0) : 0.0 } }
      @y_title = "Share of employment (%)"
    else
      @y_title = "Employment (people)"
    end

    case @sort
    when "asc"
      raw.sort_by! { |h| h[:value] }
    when "desc"
      raw.sort_by! { |h| -h[:value] }
    else
      raw.sort_by! { |h| h[:sector].to_s }
    end

    topn = (@topn >= 1 ? @topn : raw.length)
    @chart_data = raw.first(topn)

    # Label used in chart title
    @region_label = @country_names[@region] || @region
  end
end
