require 'test_helper'

class UserTest < ActiveSupport::TestCase
  #----------------------------------------------------------------
  # 準備
  #----------------------------------------------------------------
  #セットアップ（検証用レコードの準備）
  def setup
    @user = User.new(
      name:                  "Example User",
      email:                 "user@example.com",
      password:              "foobar",
      password_confirmation: "foobar",
    )
  end

  #----------------------------------------------------------------
  # テスト
  #----------------------------------------------------------------
  # test "the truth" do
  #   assert true
  # end

  #----------------------------------------------------------------
  # ヴァリデーションのテスト
  test "should be valid" do
    assert @user.valid?
  end

  #----------------------------------------------------------------
  # nameの存在のテスト
  test "name should be present" do
    @user.name = "      "
    assert_not @user.valid?
  end

  #----------------------------------------------------------------
  # emailの存在のテスト
  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
  end

  #----------------------------------------------------------------
  # nameの長さのテスト
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end


  #----------------------------------------------------------------
  # emailの長さのテスト
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end


  #----------------------------------------------------------------
  # emailの形式テスト（正しい）
  test "email validation should accept valid addresses" do
    # すべて正当なメールアドレス
    valid_addresses = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.cn
    ]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  #----------------------------------------------------------------
  # emailの形式テスト（間違い）
  test "email validation should reject invalid addresses" do
    # すべて不正なメールアドレス
    invalid_addresses = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
      foo@bar..com
    ]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end


  #----------------------------------------------------------------
  # emailの重複テスト
  test "email addresses should be unique" do
    duplicate_user       = @user.dup          #ユーザー複製
    duplicate_user.email = @user.email.upcase #メールアドレスを大文字に変換
    @user.save()
    assert_not duplicate_user.valid?
  end


  #----------------------------------------------------------------
  # emailのダウンケーステスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM" # 大小文字が混じったメールアドレス
    @user.email = mixed_case_email
    @user.save()
    assert_equal mixed_case_email.downcase, @user.reload.email
  end


  #----------------------------------------------------------------
  # passwordの存在チェック
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not@user.valid?
  end

  #----------------------------------------------------------------
  # passwordの最小文字数チェック
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not@user.valid?
  end
end
