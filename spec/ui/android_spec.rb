require 'spec_helper'

RSpec.describe "", :type => :android do
  context "Android tests" do
    after(:context) do
      TestLogger.info("Clean up after test...")
      remove_user @username
      TestLogger.info("----------------------------------------------------\n")
    end

    it "authorization through email should be OK" do
      TestLogger.info("Authorization through email started...")
      @username = Config.contacts.email
      send_code(@username)

      auth_in_ui('email')

      expect(element_exists_by_id?("action_login")).to eq(false)
    end

    it "get card should be OK" do
      title = 'Дантист'
      find_card(title)
      get_card(title)

      title = %("#{title}")

      expect(xpath("//android.view.View[contains(@resource-id, 'toolbar')]/android.widget.TextView").text == "#{t(:my, [:cards])}").to eq(true)
      expect(element_exists_by_xpath?("//android.widget.TextView[contains(@text, #{title})]"))
    end

    it "add card should be OK" do
      id("fab").click
      title = '"Ромашка"'
      find_card(title)
      add_card(title)

      title = %('#{title}')

      expect(xpath("//android.view.View[contains(@resource-id, 'toolbar')]/android.widget.TextView").text == "#{t(:my, [:cards])}").to eq(true)
      expect(element_exists_by_xpath?("//android.widget.TextView[contains(@text, #{title})]"))
    end
  end
end
