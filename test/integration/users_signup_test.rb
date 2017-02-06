require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # --------------------------------------------------------------
  #ユーザー新規登録 validateエラー
  test "invalid signup information" do
    #まず入力フォームのページにアクセス
    get signup_path

    # このブロックの実行前後で User.count の値が変わらないことをテストしている。
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name:                  "",
          email:                 "user@invalid",
          password:              "foo",
          password_confirmation: "bar",
        }
      }
    end

    assert_template 'users/new'
    # エラーメッセージのHTML要素の検証
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end


  # --------------------------------------------------------------
  #ユーザー新規登録 正常成功
  test "valid signup information" do
    #まず入力フォームのページにアクセス
    get signup_path

    # このブロックの実行前後で User.count の値が変わらないことをテストしている。
    assert_difference('User.count', 1) do
      post users_path, params: {
        user: {
          name:                  "valid user",
          email:                 "user@valid.com",
          password:              "foobar",
          password_confirmation: "foobar",
        }
      }
    end

    # リダイレクト指定に従う
    follow_redirect!

    assert_template 'users/show'
    # フラッシュメッセージのHTML要素の検証
    assert_select 'div.alert-success'

    assert_not flash[:success].empty? # フラッシュメッセージがカラではないことを確認

    # ログインできているか確認
    assert is_logged_in?
  end

end

