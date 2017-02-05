require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # --------------------------------------------------------------
  #���[�U�[���O�C��
  test "invalid login" do
    #�܂����O�C���t�H�[���̃y�[�W�ɃA�N�Z�X
    get login_path
    assert_template 'sessions/new'

    # �킴�ƊԈ�������[���A�h���X/�p�X���[�h�𑗐M
    post(
      login_path,
      params:{
        session:{
          email:   "ishiisecond@gmail.com",
          pssword: "777ab",
        }
      }
    )

    # �F�؎��s���̕\���e���v���[�g
    assert_template 'sessions/new'

    # �t���b�V�����b�Z�[�W���J���ł͂Ȃ����Ƃ��m�F
    assert_not flash[:danger].empty?

    #�܂����O�C���t�H�[���̃y�[�W�ɃA�N�Z�X
    get login_path
    # �t���b�V�����b�Z�[�W���J���ł�����m�F
    assert flash.empty?
  end
end
