class AddConfirmationMessageSentToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :confirmation_message_sent, :boolean
  end
end
