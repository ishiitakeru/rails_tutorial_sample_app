require 'test_helper'

# ユーザー一覧統合テスト
class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # セットアップ
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  # ------------------------------------------------------------
  # ユーザー一覧　ページネーション込み
  test "index as admin including pagination and delete links" do
    # ログイン状態　管理者権限
    log_in_as(@admin)

    # ページにアクセス
    get users_path
    assert_template("users/index")
    assert_select("div.pagination", count: 2) # ページネーションパーツが上下で2個あるのでcount: 2

    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      # ページネーションで取得された各ユーザーについて、ユーザー名で正しい陸が作成されているかチェック
      assert_select 'a[href=?]', user_path(user), text: user.name

      # ユーザーが管理者本人でなければ削除リンクを表示
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end

    # 削除を実行するとレコードが減る
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end


  # ------------------------------------------------------------
  # ユーザー一覧　ページネーション込み　管理者でないユーザー
  test "index as non-admin" do
    # 管理者でないユーザーでログイン
    log_in_as(@non_admin)
    get users_path

    # 削除リンクが表示されないこと
    assert_select 'a', text: 'delete', count: 0
  end
end
