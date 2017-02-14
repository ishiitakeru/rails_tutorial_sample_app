class UsersController < ApplicationController
  # beforeアクション指定
  before_action(
    :logged_in_user,                             # 第一引数 : シンボル名＝実行するメソッド名
    { only: [:index, :edit, :update, :destroy] } # 第二引数 : ハッシュ。編集関係はログインしてないとできない。
  )
  before_action(
    :correct_user,             # 第一引数 : シンボル名＝実行するメソッド名
    { only: [:edit, :update] } # 第二引数 : ハッシュ。編集関係はログインしてないとできない。
  )
  before_action(
    :admin_user,           # 第一引数 : シンボル名＝実行するメソッド名
    { only: [:destroy, ] } # 第二引数 : ハッシュ。削除は管理者ユーザーでないと実行できない。
  )

  # ---------------------------------------------------------
  # ユーザー一覧表示　ページネーション考慮必要
  def index
    @title = "All Users"

    # ページネートのために必要なページ数
    @page = params[:page]
    @users = User.paginate(page: @page)
    p @users
  end


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
      # ログインさせる
      log_in @user

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
  # ユーザー情報編集　フォーム表示　/users/(id)/edit
  def edit
    @title = "Edit user"
    @user = User.find(params[:id])
  end

  # ---------------------------------------------------------
  # ユーザー情報更新書き込み
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) # user_params は自作メソッド。このクラスのprivateメソッド.入ってくるパラメータを制限するもの。この名称はレイルズの慣例に従っている。
      # 更新成功
      # フラッシュメッセージに成功報告
      flash[:success] = "Profile updated"
      redirect_to(@user)
    else
      # 更新失敗
      render 'edit'
    end
  end

  # ---------------------------------------------------------
  # ユーザー削除
  def destroy
    user = User.find_by(id: params[:id])
    if((user.present?)&&(user != current_user?(user)))
      user.destroy()
      flash[:success] = "User[id:#{user.id}] deleted"
      redirect_to users_url
    end
  end


  # ---------------------------------------------------------
  # private
  # ---------------------------------------------------------
  private
  # インデントを一段深くして区別しやすくしている。

    # Rails推奨の送信値検査。Strong Parametersというテクニック。
    # 許可属性を設定する。
    # adminのように重要なフィールドを不正なリクエストで変更できないように保護するのが目的。
    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
      )
    end

    # ------------------------------------------------------------
    # beforeアクション
    # ------------------------------------------------------------
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        store_location() # ログイン後にリダイレクトすべきURLを記憶する。session_controller.store_location()
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      # ページが参照しようとするユーザーはGETのURLでIDが送信される。
      @user = User.find_by(id: params[:id])
      unless current_user?(@user)
        redirect_to(root_url)  # sessions_helper.current_user?(user) セッションやクッキーに保存されているログイン済みユーザーと比較する
      end
    end

    # 管理者権限を持つユーザーかどうか確認
    def admin_user
      if((current_user.nil?)||(current_user.admin? == false))
        redirect_to(root_url) # 現在ログイン中のユーザーはcurrent_userで取得できる
      end
    end

end
