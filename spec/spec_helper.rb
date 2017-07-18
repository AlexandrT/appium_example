require 'uri'
require 'appium_lib'
require 'i18n'
require File.expand_path("../../lib/config.rb", __FILE__)
require File.expand_path("../../lib/test_logger.rb", __FILE__)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require f }

  config.include Helpers, type: :request

  I18n.load_path = Dir['locale/*.yml']
  I18n.backend.load_translations
  I18n.default_locale = :en

  config.include UiHelpers::Android, type: :android
  config.include UiHelpers::IOS, type: :ios

  config.before(:all, :type => :android) do
    options = {
      caps: {
        platformName: 'Android',
        appActivity: 'view.main.MainActivity',
        appPackage: 'com.example.app',
        app: Config.apk_path,
        deviceName: 'test',
        autoGrantPermissions: true,
        clearSystemFiles: true,
        appWaitDuration: 90,
        unicodeKeyboard: true
      },

      launchTimeout: 40000
    }

    driver = Appium::Driver.new(options).start_driver
    driver.manage.timeouts.implicit_wait = 120
    Appium.promote_appium_methods Object
  end

  config.before(:all, :type => :ios) do
    options = {
      caps: {
        platformName: 'iOS',
        platformVersion: '9.3',
        automationName: 'XCUITest',
        bundleId: 'com.example.app',
        deviceName: 'iPhone 6',
        udid: '03C0A9E8-F2EE-4AF1-A152-658575B98FF1',
        appName: '/Users/alexandert/www/example.app'
      },

      launchTimeout: 40000
    }

    driver = Appium::Driver.new(options).start_driver
    driver.manage.timeouts.implicit_wait = 10
    Appium.promote_appium_methods Object
  end

  config.after(:all, :type => :android, :ios => true) do
    driver.remove_app 'com.example.app'
    driver.quit
  end
end
