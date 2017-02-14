class AddAdminToUsers < ActiveRecord::Migration[5.0]
  def change
    #                                    ディフォルトでは管理者ではない
    add_column :users, :admin, :boolean, default: false
  end
end
