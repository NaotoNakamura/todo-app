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

  describe "POST /create" do
    context "有効なパラメータの場合" do
      let(:valid_params) { { task: { title: "New Task", started_at: Time.now, finished_at: Time.now + 1.hour, is_completed: false } } }

      it "タスクが作成され、HTTP ステータス 201 が返ること" do
        post tasks_path, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["title"]).to eq("New Task")
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params) { { task: { title: "" } } }

      it "タスクが作成されず、HTTP ステータス 422 が返ること" do
        post tasks_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Title can't be blank")
      end
    end
  end
end
