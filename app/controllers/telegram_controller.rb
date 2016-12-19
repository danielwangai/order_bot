require 'telegram'

class TelegramController < ApplicationController
  def incoming
    # test if user exists
    chat_id = params["message"]["chat"]["id"]
    message = params["message"]["text"]

    if message == "/start"
      customer = Customer.find_by(telegram_id: chat_id)

      # if customer exists - other options
      if !customer.nil?
        Telegram.send_message(chat_id, "Options ", true, [])
      else
        # else prompt for account number
        Telegram.send_message(chat_id, "Key in your RedFlight account_number account_number.", true, [])
      end

    elsif message.starts_with? "/ac"
      set_account_number message, chat_id
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
end
