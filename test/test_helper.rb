ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

#Red, Green, Refactor の色表示分け設定
require "minitest/reporters"
Minitest::Reporters.use!

# こっちは単体テスト用のヘルパーらしい
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # 他所で作ったヘルパーのインクルード
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
  # ------------------------------------------------------------
  # ヘルパーメソッド
  # ------------------------------------------------------------

  # テストユーザーがログイン中の場合にtrueを返す
  # sessions_helperにある「log_in?」メソッドと同じ内容だがヘルパーメソッドはテストから呼び出せないのでテストのために新たに作り直す。
  def is_logged_in?
    !session[:user_id].nil?
  end

  # ユーザーを指定してテスト内で擬似的にログインさせる
  def log_in_as(user)
    session[:user_id] = user.id
  end

end

# ----------------------------------------------------------
# さらに別のクラスをこの中に定義するらしい
# こっちは統合テスト用のヘルパーらしい
class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする
  def log_in_as(
    user,
    password:    'password',
    remember_me: '1'
  )
    post(
      login_path,
      params: {
        session: {
          email:       user.email,
          password:    password,
          remember_me: remember_me
        }
      }
    )
  end
end
