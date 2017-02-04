class UsersController < ApplicationController

  # ---------------------------------------------------------
  # 新規登録フォーム表示
  def new
    #debugger
    @title = "Sign up"

    # 空のユーザーインスタンスを予め作っておく。フォームでこの中に値を充填する。
    @user = User.new
  end

  # ---------------------------------------------------------
  # 新規登録実行
  def create
    # 送信値受取（間違ったやり方）
    # @user = User.new(params[:user]) # この書き方はエラーになる。レイルズの持つセキュリティ対策の仕組みがこれを許さないようになっている。

    # 送信値受取（正しいやり方）
    @user = User.new(user_params) # コントローラークラスに慣習的に作る「user_params」というメソッドによって、受信を許可するパラメータを設定する。

    if(@user.save())
      # 新規作成成功

      # フラッシュメッセージのセット
      flash[:success] = "Welcome to the Sample App!"

      # 詳細画面にリダイレクト
      # redirect_to user_url(@user) と同じ意味
      # p user_url(@user) とすると、このユーザーの詳細ページのフルURLが出力される。
      # この「user_url」は、Userリソースに対するルーティングを設定したことによって自動的に使えるようになるリンク先ヘルパーらしい。「xxxx_path」「xxxx_url」
      #   xxx_path はリダイレクト以外の遷移時に使う
      #   xxx_url はリダイレクト時に使う
      redirect_to @user

    else
      #新規作成失敗
      render 'new'
    end
  end


  # ---------------------------------------------------------
  # 詳細表示
  def show
    @user = User.find(params[:id])
    @title = @user.name
    p user_url(@user)  # "http://localhost:3000/users/2" フルURLが返る
    p user_path(@user) # "/users/2"                      相対パスが返る

    # debugger #rails s を実行してるコンソールが (byebug) 状態になる。Ctrl + d で終了。
  end


  # ---------------------------------------------------------
  # private
  # ---------------------------------------------------------
  private
  # インデントを一段深くして区別しやすくしている。

    # Rails推奨の送信値検査。Strong Parametersというテクニック。
    # 許可属性を設定する。
    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation
      )
    end

end
