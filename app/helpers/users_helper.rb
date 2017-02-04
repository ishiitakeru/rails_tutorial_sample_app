# User���f���̂��߂̃w���p�[
module UsersHelper

  # �����ŗ^����ꂽ���[�U�[��Gravatar�摜��Ԃ�
  def gravatar_for(
    user,
    options = {size: 50, }
  )
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)  # ���[���A�h���X�ɑ啶�����������������Ă����v�Ȃ悤�ɑS���������ɕϊ����Ă���B
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
