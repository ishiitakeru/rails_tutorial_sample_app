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
    @title = "Home"
  end

  def help
    @title = "Help"
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

  def login
    @title = "Log in"
  end
end
