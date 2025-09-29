# frozen_string_literal: true
require "rails_helper"

RSpec.describe EmploymentSample do
  let(:path) { Rails.root.join("db/samples/employment_sample.tsv") }

  it "lists regions and stressors" do
    regions = EmploymentSample.available_regions(path)
    expect(regions.first(12)).to eq(%w[AT AT AT AT BE BE BE BE DE DE DE DE])
    expect(regions.length).to be >= 12
    stressors = EmploymentSample.available_stressors(path)
    expect(stressors.first).to eq("Employment people: Low-skilled male")
    expect(stressors.length).to be >= 3
  end

  it "extracts sector/value pairs for a stressor" do
    data = EmploymentSample.for_region_and_stressor(
      path: path,
      region: "AT",
      stressor: "Employment people: Low-skilled female"
    )
    expect(data.size).to eq(4)
    wheat = data[1] # second sector is Wheat in AT slice
    expect(wheat[:sector]).to eq("Wheat")
    expect(wheat[:value]).to be_within(1e-12).of(0.0997684101069)
  end
end
