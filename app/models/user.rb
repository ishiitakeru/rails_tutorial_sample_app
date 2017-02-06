class User < ApplicationRecord
  #-----------------------------------------------------------------------
  # パスワード設定
  #-----------------------------------------------------------------------
  # password_digest フィールドが必要になる
  # これによってauthenticateメソッドが使えるようになる。
  has_secure_password

  #-----------------------------------------------------------------------
  # ヴァリデーション設定
  #-----------------------------------------------------------------------

  # emailアドレス検証用正規表現 Regexp（正規表現）インスタンス
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # VALID_EMAIL_REGEX = Regexp.new(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)  # こう書いても良い
  # 大文字で始まる名前はRubyでは定数を意味する。

  # ドットがふたつ以上続くアドレスも弾く場合
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # name
  validates :name,
            presence: true,
            length:   { maximum: 50 }

  # email
  validates(
    :email,
    presence:   true,
    length:     { maximum: 255 },
    format:     { with: VALID_EMAIL_REGEX }, # format{ with: /正規表現/ }  フォーマットチェック。メールアドレスの検証などに有効。
    uniqueness: { case_sensitive: false },   # 一意である必要があるが大文字小文字は区別しない
  )

  # password
  validates(
    :password,
    presence:   true,
    length:     { minimum: 6 },
  )


  #-----------------------------------------------------------------------
  # クラスメソッド
  #-----------------------------------------------------------------------

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end


  #-----------------------------------------------------------------------
  # コールバック
  #-----------------------------------------------------------------------

  # 保存前に実行される
  before_save {
    #            右辺では「self.」を省略できる
    #self.email = email.downcase

    # 末尾に「!」を付けると呼び出すだけで呼び出し元を変更する
    self.email.downcase!
  }


end
