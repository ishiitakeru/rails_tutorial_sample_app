class StaticPagesController < ApplicationController
  # クラス変数 @@（PHPでいうところのプロパティ）
  # クラスメソッド（static function）から参照可能
  # インスタンスメソッド（function）から参照可能
  @@common_title = "Ruby on Rails Tutorial Sample App"

  # クラスインスタンス変数 @（PHPでいうところのスタティックプロパティ）
  # クラスメソッド（static function）から参照可能
  # インスタンスメソッド（function）から参照「不」可能
  @class_instance_value_test = "class_instance_value_test"

  def home
    @title = "Home | #{@@common_title}"
  end

  def help
    @title = "Help | #{@@common_title}"
  end

  def about
    @title = "About | #{@@common_title}"
  end

  def contact
    @title = "Contact | #{@@common_title}"
  end
end
