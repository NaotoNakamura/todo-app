class Api::AuthController < ApplicationController
  skip_before_action :authenticate_request

  def google
    validator = GoogleIDToken::Validator.new
    begin
      # GoogleのIDトークンを検証
      payload = validator.check(params[:id_token], ENV["GOOGLE_CLIENT_ID"])

      # uid と provider で検索。なければ作成
      user = User.find_or_initialize_by(provider_name: "google", provider_uid: payload["sub"])

      # 常に最新の情報を反映させる
      user.email = payload["email"]
      user.name = payload["name"]
      user.provider_name = "google"
      user.provider_uid = payload["sub"]

      user.save!

      # Rails独自のJWTを発行
      token = JWT.encode(
        { user_id: user.id, exp: 24.hours.from_now.to_i },
        ENV["JWT_SECRET_KEY"],
        "HS256"
      )

      render json: { access_token: token }
    rescue GoogleIDToken::ValidationError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
end
