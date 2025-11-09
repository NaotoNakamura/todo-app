require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /index" do
    before { create(:task, title: "Test Task 1") }

    it "HTTP ステータス 200 が返ること" do
      get tasks_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Test Task 1")
    end
  end
end
