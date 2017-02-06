require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # --------------------------------------------------------------
  # セットアップ
  def setup
    @user = users(:michael)
  end


  # --------------------------------------------------------------
  #ユーザーログイン失敗時
  test "login with invalid information" do
    #まずログインフォームのページにアクセス
    get login_path
    assert_template 'sessions/new'

    # わざと間違ったメールアドレス/パスワードを送信
    post(
      login_path,
      params:{
        session:{
          email:    "ishiisecond@gmail.com",
          password: "777ab",
        }
      }
    )

    # 認証失敗時の表示テンプレート
    assert_template 'sessions/new'

    # フラッシュメッセージがカラではないことを確認
    assert_not flash[:danger].empty?

    #まずログインフォームのページにアクセス
    get login_path
    # フラッシュメッセージがカラであるを確認
    assert flash.empty?
  end


  # --------------------------------------------------------------
  #ユーザーログイン成功時
  test "login with valid information" do
    #まずログインフォームのページにアクセス
    get login_path
    assert_template 'sessions/new'

    # 正しいメールアドレス/パスワードを送信
    post(
      login_path,
      params:{
        session:{
          email:    @user.email,
          password: 'password',
        }
      }
    )

    # ログイン成功時のリダイレクト
    assert_redirected_to @user # assert_redirected_to 正しくリダイレクトされるかどうかのチェック
    follow_redirect!           # テスト動作にリダイレクトを追跡させる。

    # 認証成功時の表示テンプレート
    assert_template 'users/show'

    #ヘッダーリンク確認
    assert_select "a[href=?]", login_path, count: 0 # count: 0 とすることで「そのリンクが表示されない」ことを確認できる。
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

  end


  # --------------------------------------------------------------
  #ユーザーログイン成功、ログアウト成功
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }

    # テストヘルパーに定義したログイン確認関数
    assert is_logged_in?

    # リダイレクトとその追跡
    assert_redirected_to @user
    follow_redirect!

    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # ログアウトのルーティング。POSTではなくDELETEメソッド。ログアウト処理が呼ばれるはず。
    delete logout_path

    # ログイン確認変数。ログアウト状態か確認。
    assert_not is_logged_in?

    # リダイレクト追跡
    assert_redirected_to root_url
    follow_redirect!

    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
