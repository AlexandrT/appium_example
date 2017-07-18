require File.expand_path("../helpers.rb", __FILE__)

module UiHelpers
  module Android
    include Helpers

    def allow_geo
      begin
        allow_btn = xpath("//android.widget.Button[contains(@text, 'ALLOW')]")
        allow_btn.click
      rescue Selenium::WebDriver::Error::NoSuchElementError
      end
    end

    def close_alert
      id("android:id/button1").click
    end

    def auth_in_ui(type)
      raise(Exception.new("Unknown auth type #{type}")) unless ["phone", "email"].include?(type)

      xpath("//android.widget.TextView[contains(@text, '#{t(:skip, [:splash_screen])}')]").click
      find_element(:id => "action_login").click

      case type
      when "email"
        find_element(:id => "email_button").click

        contact = Config.contacts.email
      when "phone"
        find_element(:id => "phone_button").click

        contact = Config.contacts.phone
      end

      find_element(:id => "login_input").send_keys(contact)
      find_element(:id => "submit").click

      code = Helpers.get_secret(contact)

      find_element(:id => "code_input").send_keys(code)
      find_element(:id => "submit").click

      find_element(:id => "close_button").click

      fill_info if xpath("//android.widget.TextView[contains(@text, '#{t(:fill, [:profile])}')]")
    end

    def fill_info
      find_element(:class => "android.widget.EditText").send_keys("test")
      find_element(:id => "date_birthday").click
      find_element(:id => "button1").click
      find_element(:id => "sexMale").click
      find_element(:id => "send_button").click
    end

    def element_exists_by_id?(id)
      if find_elements(:id, id).size == 0
        false
      else
        true
      end
    end

    def element_exists_by_xpath?(xpath)
      if find_element(:xpath, xpath).size == 0
        false
      else
        true
      end
    end

    def get_card(text)
      text = %("#{text}")

      xpath("//android.widget.FrameLayout/*/android.widget.TextView[contains(@text, #{text})]").click
      find_element(:id => "get_card_button").click
      xpath("//android.widget.Button[contains(@text, '#{t(:all, [:cards])}')]").click
    end

    def add_card(text)
      text = %('#{text}')
      xpath("//android.widget.FrameLayout/*/android.widget.TextView[contains(@text, #{text})]").click
      id("add_card_button").click

      id("card_number_input").send_keys("00001589")
      id("submit").click
      xpath("//android.widget.Button[contains(@text, '#{t(:all, [:cards])}')]").click

    end

    def scroll_to(text)
      text = %("#{text}")

      args = scroll_uiselector("new UiSelector().textContains(#{text})")

      find_element :uiautomator, args
    end

    def find_card(text)
      id("search_widget").click
      id("search_src_text").send_keys(text)
    end

    def t(key, scope)
      I18n.translate key, scope: scope
    end
  end

  module IOS
    include Helpers

    def auth(type)
      raise(Exception.new("Unknown auth type #{type}")) unless ["phone", "email"].include?(type)

      find_element(:id => "Allow").click
    end
  end
end

