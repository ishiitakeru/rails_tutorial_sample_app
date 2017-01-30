require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  # 単体テスト
  # ApplicationHelper.full_title のテスト
  test "full title helper" do
    # 引数なしの場合
    assert_equal full_title,         'Ruby on Rails Tutorial Sample App'
    # 引数が「Help」の場合
    assert_equal full_title("Help"), 'Help | Ruby on Rails Tutorial Sample App'
  end
end
