# ログイン機能のためのセッションヘルパー
module SessionsHelper

  # ログイン
  def log_in(user)
    # Railsがディフォルトで持っているsessionメソッドを利用する。これは作成したSessionsコントローラーとは無関係にレイルズがもともと持っている。
    session[:user_id] = user.id # 「user_id」という名前のセッションにDBに保存されているユーザーIDを格納。暗号化される。

    # sessionメソッド : ブラウザを閉じると内容を破棄
    # cookiesメソッド : ブラウザを閉じても内容を保持
  end
end
