require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, ENV['JWT_SECRET_KEY'], 'HS256') }
  let(:auth_headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /index" do
    before { create(:task, title: "Test Task 1", user: user) }

    it "HTTP ステータス 200 が返ること" do
      get tasks_path, headers: auth_headers
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Test Task 1")
    end

    it "認証なしでアクセスすると401が返ること" do
      get tasks_path
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /create" do
    context "有効なパラメータの場合" do
      let(:valid_params) { { task: { title: "New Task", started_at: Time.now, finished_at: Time.now + 1.hour, is_completed: false } } }

      it "タスクが作成され、HTTP ステータス 201 が返ること" do
        post tasks_path, params: valid_params, headers: auth_headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["title"]).to eq("New Task")
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params) { { task: { title: "" } } }

      it "タスクが作成されず、HTTP ステータス 422 が返ること" do
        post tasks_path, params: invalid_params, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Title can't be blank")
      end
    end
  end

  describe "PATCH /update" do
    let!(:task) { create(:task, title: "Old Title", user: user) }

    context "有効なパラメータの場合" do
      let(:valid_params) { { task: { title: "Updated Title" } } }

      it "タスクが更新され、HTTP ステータス 200 が返ること" do
        patch task_path(task), params: valid_params, headers: auth_headers
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["title"]).to eq("Updated Title")
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params) { { task: { title: "" } } }

      it "タスクが更新されず、HTTP ステータス 422 が返ること" do
        patch task_path(task), params: invalid_params, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Title can't be blank")
      end
    end

    context "他のユーザーのタスクの場合" do
      let(:other_user) { create(:user) }
      let!(:other_task) { create(:task, title: "Other Task", user: other_user) }

      it "404が返ること" do
        patch task_path(other_task), params: { task: { title: "Hacked" } }, headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:task) { create(:task, user: user) }

    it "タスクが削除され、HTTP ステータス 204 が返ること" do
      expect {
        delete task_path(task), headers: auth_headers
      }.to change(Task, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
