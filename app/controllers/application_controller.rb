class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # ログインのためのセッションヘルパーをインクルード
  include SessionsHelper

  #ディフォルトページ
  def hello
    render html: "hello, world!"
  end

end
