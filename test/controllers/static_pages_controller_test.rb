require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  # すべてのテスト実行前に実行される
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  #static_pages/home がGETメソッドで正常に動作するかのテスト
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  #static_pages/help がGETメソッドで正常に動作するかのテスト
  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  #static_pages/about がGETメソッドで正常に動作するかのテスト
  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  #static_pages/contact がGETメソッドで正常に動作するかのテスト
  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end
