class SessionsController < ApplicationController

  # -----------------------------------------------------------
  # get ログインフォーム表示
  def new
    @title = "Log in"
  end


  # -----------------------------------------------------------
  # post ログイン実行
  def create
    @title = "Log in"

    # ユーザーをメールアドレスから検索
    @user = User.find_by(email: params[:session][:email].downcase)

    if(
      (@user.present?)&&
      (@user.authenticate(params[:session][:password])) # Userモデルクラスに設定した has_secure_password によって有効になった authenticate メソッドを使う。パスワードが間違っていればfalse
    )
      # 認証成功

      # sessionヘルパーに作成したメソッド呼び出し
      log_in(@user)

      # ログイン状態を覚えておくチェックが入っていればクッキーを使ったログイン状態保持を行う
      #                              条件      trueの時         falseの時
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) # クッキーを利用してログイン状態永続化

      # ユーザー情報ページにリダイレクト。引数はユーザーインスタンス
      redirect_to @user

    else
      # 認証失敗

      # エラーメッセージ作成
      # flash[:danger] = "メールアドレスかパスワードが間違っています。" # flash.nowを使わない場合はViewのあるURLにリダイレクトさせる
      # redirect_to login_url # リダイレクトには_urlを使う

      # ログインできなかった場合、ログインフォームを再度表示
      flash.now[:danger] = "メールアドレスかパスワードが間違っています。" # 表示後にリクエストが生じたら消えるフラッシュメッセージ。ここではリダイレクトさせずにrenderでテンプレートを表示しているので通常のフラッシュ表示指定だとメッセージが消えるタイミングがずれる。
      render 'new'

    end

  end


  # -----------------------------------------------------------
  # delete ログアウト
  def destroy
    # ヘルパーに作成したログアウトメソッド呼び出し
    log_out if log_in?

    redirect_to root_url
  end

end
