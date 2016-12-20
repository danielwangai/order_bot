require 'test_helper'

class TelegramControllerTest < ActionDispatch::IntegrationTest
  test "should get incoming" do
    get telegram_incoming_url
    assert_response :success
  end

end
