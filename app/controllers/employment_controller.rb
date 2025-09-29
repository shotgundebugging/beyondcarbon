class EmploymentController < ApplicationController
  def index
    @regions = Region.order(:code).pluck(:code)
    @stressors = EmploymentData.distinct.order(:stressor).pluck(:stressor)
    @country_names = Region.pluck(:code, :name).to_h

    @region = params[:region].presence || @regions.first
    @stressor = params[:stressor].presence || @stressors.first

    @chart_data = EmploymentData.joins(:region)
                                .where(regions: { code: @region }, stressor: @stressor)
                                .select(:sector, :value)
                                .map { |r| { sector: r.sector, value: r.value.to_f } }

    rows = EmploymentData.joins(:region).where(regions: { code: @region })
    @region_dataset = rows.group_by(&:stressor)
                          .transform_values { |arr| arr.map { |r| { sector: r.sector, value: r.value.to_f } } }
  end
end
