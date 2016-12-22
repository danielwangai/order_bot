require 'telegram'

class TelegramController < ApplicationController
  def incoming
    # test if user exists
    chat_id = params["message"]["chat"]["id"]
    message = params["message"]["text"]

    customer = Customer.find_by(telegram_id: chat_id)
    if message == "/start"
      # if customer exists - other options
      if !customer.nil?
        Telegram.send_message(chat_id, "Choose one of the following service options.", false, [['status'], ['No']])
      else
        # else prompt for account number
        Telegram.send_message(chat_id, "Key in your RedFlight account_number account_number.", true, [])
      end

    elsif message.starts_with? "/ac"
      set_account_number message, chat_id
    elsif message == "status" || message == "/status"
      # get current_user id from telegram_id and use it to get cost
      transaction = Transaction.where("customer_id = ? and is_paid = ?", customer.id, false).sum("total_cost")
      Telegram.send_message(chat_id, "Your total expenduture is #{transaction}", true, [])
    elsif message == "Confirm"
      # set confirmed to true
      transaction = Transaction.find_by(customer_id: customer.id)
      transaction.update(confirmation_message_sent: true)
      Telegram.send_message(chat_id, "Order is confirmed.", true, [])
    end
    puts "----------#{chat_id}"
    render json: params
  end

  # test if user exists
  def set_account_number message, chat_id
    # get account_number
    re = /(\d+)/
    account_number = message.split(re)[1]
    customer_account = Customer.find_by(account_number: account_number)
    if !customer_account.nil?
      # save account_number

      # check if telegram_id exists
      if customer_account.telegram_id.nil?
        # if telegram_id doesnt exist, update
        customer_account.update(telegram_id: chat_id)
        customer_account.save!
        Telegram.send_message(chat_id, "Thank you, #{customer_account.name} for registering to RedFlight telegram self-service.", true, [])
      else
        Telegram.send_message(chat_id, "Thank you, #{customer_account.name} for your continued use of RedFlight Services.", true, [])
      end
    end
  end

  def check_account_status

  end
end
