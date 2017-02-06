# ログイン機能のためのセッションヘルパー
module SessionsHelper

  # ------------------------------------------------------------
  # ログイン
  def log_in(user)
    # Railsがディフォルトで持っているsessionメソッドを利用する。これは作成したSessionsコントローラーとは無関係にレイルズがもともと持っている。
    session[:user_id] = user.id # 「user_id」という名前のセッションにDBに保存されているユーザーIDを格納。暗号化される。

    # sessionメソッド : ブラウザを閉じると内容を破棄
    # cookiesメソッド : ブラウザを閉じても内容を保持
  end

  # ------------------------------------------------------------
  # ログイン中の現在のユーザーを返す。
  # インスタンス変数に保持しておき、一度検索済みであればそれを返して検索回数を減らす。
  def current_user
    # Rubyに独特の「||=(or equals)演算子」を使う。左辺がfalseなら右辺を実行し代入する。
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # ------------------------------------------------------------
  # ログインしているかどうかを返す。
  # 
  # @return ログインしていていればtrue / ログインしていなければfalse
  def log_in?
    !current_user.nil?
  end

  # ------------------------------------------------------------
  # ログアウト
  def log_out
    # Railsがディフォルトで持っているsessionメソッドを利用する。
    session.delete(:user_id)
    @current_user = nil
  end

end
