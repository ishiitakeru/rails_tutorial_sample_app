require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # --------------------------------------------------------------
  #ユーザーログイン
  test "invalid login" do
    #まずログインフォームのページにアクセス
    get login_path
    assert_template 'sessions/new'

    # わざと間違ったメールアドレス/パスワードを送信
    post(
      login_path,
      params:{
        session:{
          email:   "ishiisecond@gmail.com",
          pssword: "777ab",
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
end
