class User < ApplicationRecord
  #-----------------------------------------------------------------------
  # パスワード設定
  #-----------------------------------------------------------------------
  # password_digest フィールドが必要になる
  # これによってauthenticateメソッドが使えるようになる。
  has_secure_password

  #-----------------------------------------------------------------------
  # クラス変数
  # データベースにフィールドがなくてもここで設定すれば「モデル名.変数名」が有効になる。
  #-----------------------------------------------------------------------
  attr_accessor :remember_token

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
    allow_nil: true,      # パスワードの空欄は許可する。has_secure_password指定があるので新規作成時には空欄だとちゃんとエラーになる。更新時のみこの指定が活きる。
  )


  #-----------------------------------------------------------------------
  # クラスメソッド
  # class << self ブロックで設定する
  #-----------------------------------------------------------------------
  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す。ログイン保持（remember_me機能）に使うremember_token生成などに利用。
    def new_token
      SecureRandom.urlsafe_base64
    end
  end


  #-----------------------------------------------------------------------
  # public functions
  #-----------------------------------------------------------------------
  # ログイン状態の記憶
  def remember
    # アクセサ（プロパティのつもりで扱っているが）で設定した変数にアクセスするには「self.」をつける
    self.remember_token = User.new_token

    # ヴァリデーションを素通りしてDBを更新するメソッド「update_attribute」
    update_attribute(
      :remember_digest,
      User.digest(self.remember_token)
    )
  end


  # ------------------------------------------------------------
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    if(self.remember_digest.nil?)
      return false
    else
      #                    このremember_digestはおそらく検索結果（ユーザー一人分）のremember_digestの値のこと（self.が省略されている）
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
      #                                                  このremember_tokenはメソッドの引数
  
      # BCryptのis_password?メソッドは、「暗号化する前の値」と「暗号化したあとの値」との関係を調べるメソッドだと思われる。
    end
  end


  #-----------------------------------------------------------------------
  # ログイン状態の忘却（クッキーの削除）
  def forget
    # ヴァリデーションを素通りしてDBを更新するメソッド「update_attribute」
    update_attribute(
      :remember_digest,
      nil
    )
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
