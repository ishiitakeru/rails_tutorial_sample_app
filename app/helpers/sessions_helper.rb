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
  # ユーザーを永続的セッションに記憶する
  def remember(user)
    # Userモデルに設定したremember。rememberトークンを生成し、rememberダイジェストをDB保存。
    user.remember

    # 永続クッキーに保存
    cookies.permanent.signed[:user_id] = user.id             # ユーザーID（暗号化して）
    cookies.permanent[:remember_token] = user.remember_token # rememberトークン（すでに暗号化されている）
  end


  # ------------------------------------------------------------
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  # ------------------------------------------------------------
  # ログイン中の現在のユーザーを返す。
  # インスタンス変数に保持しておき、一度検索済みであればそれを返して検索回数を減らす。
  # セッションに保存されていればセッションから、ない場合はクッキーからユーザーIDを特定する。
  def current_user
    if(user_id = session[:user_id])
      # セッション
      # Rubyに独特の「||=(or equals)演算子」を使う。左辺がfalseなら右辺を実行し代入する。
      @current_user ||= User.find_by(id: user_id)

    elsif(user_id = cookies.signed[:user_id]) # cookies.signed は取り出す時復号化してくれる
      # クッキー
      # クッキー乗っ取り攻撃対策のために二重チェックをする
      #   1. 暗号化されたユーザーIDのチェック
      #   2. 暗号化されたremember_tokenのチェック

      # raise #テストがパスすればここがテストされていないことがわかる

      user = User.find_by(id: user_id)

      # 認証済みチェック（暗号化されたユーザーIDだけじゃなくクッキーの認証のためのトークンも検査する）
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end

  end


  # ------------------------------------------------------------
  # ログイン中のユーザーかどうかを返す
  def current_user?(user)
    return (user == current_user())
  end


  # ------------------------------------------------------------
  # ログインしているかどうかを返す。
  # 
  # @return ログインしていていればtrue / ログインしていなければfalse
  def log_in?
    !current_user.nil?
  end

  # ------------------------------------------------------------
  # ログインしているかどうかを返す。log_in? のエイリアス。
  def logged_in?
    log_in?
  end

  # ------------------------------------------------------------
  # ログアウト
  def log_out
    forget(current_user()) # クッキーを利用したログイン状態永続化を削除。current_userメソッドから現在のユーザーを取り出す

    # Railsがディフォルトで持っているsessionメソッドを利用する。
    session.delete(:user_id)

    @current_user = nil
  end

  # ------------------------------------------------------------
  # 記憶したURL（もしくはディフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    # 記録していたURLを削除
    session.delete(:forwarding_url)
  end

  # ------------------------------------------------------------
  # アクセスしようとしたURLを覚えておく
  # セッションを利用する
  def store_location()
    session[:forwarding_url] = request.original_url if request.get?
  end

end
