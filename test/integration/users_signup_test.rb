require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # --------------------------------------------------------------
  #���[�U�[�V�K�o�^ validate�G���[
  test "invalid signup information" do
    #�܂����̓t�H�[���̃y�[�W�ɃA�N�Z�X
    get signup_path

    # ���̃u���b�N�̎��s�O��� User.count �̒l���ς��Ȃ����Ƃ��e�X�g���Ă���B
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name:                  "",
          email:                 "user@invalid",
          password:              "foo",
          password_confirmation: "bar",
        }
      }
    end

    assert_template 'users/new'
    # �G���[���b�Z�[�W��HTML�v�f�̌���
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end


  # --------------------------------------------------------------
  #���[�U�[�V�K�o�^ ���퐬��
  test "valid signup information" do
    #�܂����̓t�H�[���̃y�[�W�ɃA�N�Z�X
    get signup_path

    # ���̃u���b�N�̎��s�O��� User.count �̒l���ς��Ȃ����Ƃ��e�X�g���Ă���B
    assert_difference('User.count', 1) do
      post users_path, params: {
        user: {
          name:                  "valid user",
          email:                 "user@valid.com",
          password:              "foobar",
          password_confirmation: "foobar",
        }
      }
    end

    # ���_�C���N�g�w��ɏ]��
    follow_redirect!

    assert_template 'users/show'
    # �t���b�V�����b�Z�[�W��HTML�v�f�̌���
    assert_select 'div.alert-success'

    assert_not flash[:success].empty? # �t���b�V�����b�Z�[�W���J���ł͂Ȃ����Ƃ��m�F

    # ���O�C���ł��Ă��邩�m�F
    assert is_logged_in?
  end

end

