require 'telegrammer'

# telegram class with methods for basic functionality
class Telegram
	def self.bot
		Telegrammer::Bot.new("#{ENV['TELEGRAM_BOT_TOKEN']}")
	end

	def self.reply_markup options = []
		Telegrammer::DataTypes::ReplyKeyboardMarkup.new(
			keyboard: options,
			resize_keyboard: true
		)
	end

	def self.hide_keyboard
		reply_markup = Telegrammer::DataTypes::ReplyKeyboardHide.new(
			hide_keyboard: true
		)
	end

	def self.send_message chat_id, text, hide=true, options
		if hide
			# if no options hide the keyboard
			rm = hide_keyboard
		else
			# else display them
			rm = reply_markup(options)
		end
		bot.send_message(chat_id: chat_id, text: text, rm: reply_markup)
	end

	def self.set_webhook url
		# telegram url webhook
		bot.set_webhook(url)
	end
end
