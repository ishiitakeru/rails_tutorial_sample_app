require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout links" do
    #--------------------------------------------------------------
    # 静的ページ
    get root_path
    assert_template 'static_pages/home'

    # Webページ内のタグ検査

    #                     この「?」が
    #                          この「root_path」に置き換わる
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    get contact_path
    assert_select "title", full_title("Contact")


    #--------------------------------------------------------------
    # サインアップページ
    get signup_path
    assert_template 'users/new'
  end

end
