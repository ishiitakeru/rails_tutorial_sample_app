require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  # すべてのテスト実行前に実行される
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end


  #------------------------------------------------------------------
  test "should get root" do
    get root_url
    assert_response :success
  end

  #static_pages/home がGETメソッドで正常に動作するかのテスト
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  #static_pages/help がGETメソッドで正常に動作するかのテスト
  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  #static_pages/about がGETメソッドで正常に動作するかのテスト
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  #static_pages/contact がGETメソッドで正常に動作するかのテスト
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end


end
