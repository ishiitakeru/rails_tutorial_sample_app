require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # --------------------------------------------------------------
  # �Z�b�g�A�b�v
  def setup
    @user = users(:michael)
  end


  # --------------------------------------------------------------
  #���[�U�[���O�C�����s��
  test "login with invalid information" do
    #�܂����O�C���t�H�[���̃y�[�W�ɃA�N�Z�X
    get login_path
    assert_template 'sessions/new'

    # �킴�ƊԈ�������[���A�h���X/�p�X���[�h�𑗐M
    post(
      login_path,
      params:{
        session:{
          email:    "ishiisecond@gmail.com",
          password: "777ab",
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


  # --------------------------------------------------------------
  #���[�U�[���O�C��������
  test "login with valid information" do
    #�܂����O�C���t�H�[���̃y�[�W�ɃA�N�Z�X
    get login_path
    assert_template 'sessions/new'

    # ���������[���A�h���X/�p�X���[�h�𑗐M
    post(
      login_path,
      params:{
        session:{
          email:    @user.email,
          password: 'password',
        }
      }
    )

    # ���O�C���������̃��_�C���N�g
    assert_redirected_to @user # assert_redirected_to ���������_�C���N�g����邩�ǂ����̃`�F�b�N
    follow_redirect!           # �e�X�g����Ƀ��_�C���N�g��ǐՂ�����B

    # �F�ؐ������̕\���e���v���[�g
    assert_template 'users/show'

    #�w�b�_�[�����N�m�F
    assert_select "a[href=?]", login_path, count: 0 # count: 0 �Ƃ��邱�ƂŁu���̃����N���\������Ȃ��v���Ƃ��m�F�ł���B
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

  end


  # --------------------------------------------------------------
  #���[�U�[���O�C�������A���O�A�E�g����
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }

    # �e�X�g�w���p�[�ɒ�`�������O�C���m�F�֐�
    assert is_logged_in?

    # ���_�C���N�g�Ƃ��̒ǐ�
    assert_redirected_to @user
    follow_redirect!

    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # ���O�A�E�g�̃��[�e�B���O�BPOST�ł͂Ȃ�DELETE���\�b�h�B���O�A�E�g�������Ă΂��͂��B
    delete logout_path

    # ���O�C���m�F�ϐ��B���O�A�E�g��Ԃ��m�F�B
    assert_not is_logged_in?

    # ���_�C���N�g�ǐ�
    assert_redirected_to root_url
    follow_redirect!

    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
