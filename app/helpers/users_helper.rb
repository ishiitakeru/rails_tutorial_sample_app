# Userモデルのためのヘルパー
module UsersHelper

  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(
    user,
    options = {size: 50, }
  )
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)  # メールアドレスに大文字小文字が混じっても大丈夫なように全部小文字に変換している。
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    return image_tag(
      gravatar_url,
      {
        alt:   user.name,
        class: "gravatar",
      }
    )
  end

end
