class UsersController < ApplicationController

  # 新規登録
  def new
  end

  # 詳細表示
  def show
    @user = User.find(params[:id])
    @title = @user.name
    #debugger
  end

end
