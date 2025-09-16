# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Employment", type: :request do
  it "renders the index" do
    get "/"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Employment (sample)")
  end
end

