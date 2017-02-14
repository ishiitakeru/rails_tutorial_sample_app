require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # ------------------------------------------------------------
  # セットアップ
  def setup
    @user       = users(:michael) # fixtureに記述したダミーユーザー
    @other_user = users(:archer)  # fixtureに記述したダミーユーザー
  end

  # ------------------------------------------------------------
  # 新規登録ページにアクセス
  test "should get new" do
    # get users_new_url
    get signup_path
    assert_response :success
  end

  # ------------------------------------------------------------
  # ログインしていないとき、編集画面にアクセスするとログイン画面にリダイレクトされる
  test "should redirect edit when not logged in" do
    # ログインを実行していないところがポイント

    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end


  # ------------------------------------------------------------
  # ログインしていないとき、編集実行しようとするとログイン画面にリダイレクトされる
  test "should redirect update when not logged in" do
    # ログインを実行していないところがポイント

    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end


  # ------------------------------------------------------------
  # 別ユーザーでログイン時。編集画面アクセスでルートURLへ。
test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # ------------------------------------------------------------
  # 別ユーザーでログイン時。updateは通らずルートへリダイレクト。
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end


  # ------------------------------------------------------------
  # ユーザー一覧ページ ログイン必須
  test "should redirect index when not logged in" do
    # テストにおいてはログインは明示的に行わない限り実行されない
    get users_path
    assert_redirected_to login_url
  end


  # ------------------------------------------------------------
  # adminフィールドが不正なpatch送信によって変更されないようになっているか確認
  test "should not allow the admin attribute to be edited via the web" do
    # 管理者でないアカウントでログイン
    log_in_as(@other_user)
    # 管理者でないことを確認
    assert_not @other_user.admin?

    # adminフィールドをtrueに変更する操作
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin:                 true ,} }

    # adminの値が変わっていないことを確認
    assert_not @other_user.reload.admin?
  end

  # ------------------------------------------------------------
  # ログインしてないユーザーがユーザー削除を実行した場合、ログイン画面にリダイレクト
  test "should redirect destroy when not logged in" do
    # ログインしてない
    # レコード数に変化が起きないことを確認
    assert_no_difference "User.count" do
      delete user_path(@user) # deleteメソッドでユーザーリソースにアクセス＝削除
    end

    # ログイン画面にリダイレクトされているか
    assert_redirected_to login_url
  end


  # ------------------------------------------------------------
  # 管理者でないログインユーザーがユーザー削除を実行した場合、ルートにリダイレクト
  test "should redirect destroy when logged in as a non-admin" do
    # 管理者でないアカウントでログイン
    log_in_as(@other_user)

    # レコード数に変化が起きないことを確認
    assert_no_difference "User.count" do
      delete user_path(@user) # deleteメソッドでユーザーリソースにアクセス＝削除
    end

    # ルート画面にリダイレクトされているか
    assert_redirected_to root_url
  end

end
