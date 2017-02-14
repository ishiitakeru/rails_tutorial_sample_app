require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # ------------------------------------------------------------
  # 事前セットアップ
  def setup
    @user = users(:michael) # このmichaelというのはfixtureにデータを記述してあるからここで使える。
  end

  # ------------------------------------------------------------
  # ユーザー情報更新失敗テスト
  test "unsuccessful edit" do
    # ログイン
    log_in_as(@user)

    # ユーザー編集ページにアクセス
    get edit_user_path(@user)
    assert_template 'users/edit'

    # path() はPOSTやGETやDELETEと同じでメソッドを指定してデータを送信する
    patch(
      user_path(@user),
      {
        params:{
          user:{
            name:                  "",
            email:                 "foo@invalid",
            password:              "foo",
            password_confirmation: "bar",
          }
        }
      }
    )
    # 更新失敗時はエディット画面をレンダリングする
    assert_template('users/edit')

    # フラッシュメッセージのHTML要素の検証
    assert_select 'div.alert-danger'
  end


  # ------------------------------------------------------------
  # ユーザー情報更新成功テスト
  test "successful edit" do
    # ログイン
    log_in_as(@user)

    get edit_user_path(@user)
    assert_template('users/edit')
    name  = "Foo Bar"
    email = "foo@bar.com"

    # path() はPOSTやGETやDELETEと同じでメソッドを指定してデータを送信する
    patch(
      user_path(@user),
      {
        params:{
          user:{
            name:                  name,
            email:                 email,
            password:              "",
            password_confirmation: "",
          }
        }
      }
    )

    # フラッシュメッセージに成功報告が入っている
    assert_not(flash.empty?)

    # 更新成功時はリダイレクト
    assert_redirected_to(@user)
    @user.reload()
    assert_equal(name,  @user.name)
    assert_equal(email, @user.email)
  end

  # ------------------------------------------------------------
  # ログインせずに編集ページへ→リダイレクト→ログイン→編集ページへ
  test "successful edit with friendly forwarding" do
    # ログインせずに編集ページへ
    get edit_user_path(@user)
    # ログインする
    log_in_as(@user)
    # 編集ページにリダイレクトする
    assert_redirected_to edit_user_url(@user)

    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }

    # 編集成功
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

end
