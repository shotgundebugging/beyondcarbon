class EmploymentController < ApplicationController
  def index
    sample_path = Rails.root.join("db/samples/employment_sample.tsv")

    @regions = EmploymentSample.available_regions(sample_path).uniq
    @stressors = EmploymentSample.available_stressors(sample_path)

    @region = params[:region].presence || @regions.first
    @stressor = params[:stressor].presence || @stressors.first

    @chart_data = EmploymentSample.for_region_and_stressor(
      path: sample_path,
      region: @region,
      stressor: @stressor
    )

    @region_dataset = EmploymentSample.read_dataset(sample_path)
                          .select { |h| h[:region] == @region }
                          .group_by { |h| h[:stressor] }
  end
end
