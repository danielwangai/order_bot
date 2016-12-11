class ChangeAccountNameDataTypeToString < ActiveRecord::Migration[5.0]
  def change
    change_column :customers, :account_number, :string
  end
end
