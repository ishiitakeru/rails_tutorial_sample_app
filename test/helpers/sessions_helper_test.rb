require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  # 準備　ユーザーを作成しクッキーに記憶させる
  def setup
    @user = users(:michael)
    remember(@user)
  end

  # セッションがないとき「current_user」が正しいユーザーを返す
  test "current_user returns right user when session is nil" do
    # assert_equal は「期待する値、実際の値」の順で書くこと
    assert_equal @user, current_user
    assert is_logged_in?
  end

  # 「remember_dighest」が間違っているとき、「current_user」がnilを返す
  test "current_user returns nil when remember digest is wrong" do
    # ユーザーの「remember_digest」を新しいものに入れ替える
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    # current_userの戻り値がnilであることを確認
    assert_nil current_user
  end
end

