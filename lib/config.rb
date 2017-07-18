require 'singleton'
require 'yaml'
require 'json'
require 'ostruct'
require 'forwardable'
require_relative 'string_inquirer'

class Config
  include Singleton
  extend Forwardable

  DEFAULT_ENV = "development"

  def_delegators 'self.class', :datafile, :datafile=

  attr_writer :data

  # Load config.yml for specified environment
  # @return [OpenStruct] singleton Config for prod or dev environment
  def data
    @data ||= begin
      config_path = File.join(Dir.pwd, 'config.yml')

      config_hash = YAML.load_file(config_path)[Config.env]

      if config_hash.nil?
        raise "Check that TEST_ENV environment variable is correct and this section (#{ENV['TEST_ENV']}) contained into config.yml"
        exit 1
      end

      JSON.parse(config_hash.to_json, object_class: OpenStruct)
    end
  end

  class << self

    # Hash-like access
    # @param key [String]
    def [](key)
      instance.data.send(key)
    end

    def method_missing(*args)
      instance.data.send(*args)
    end

    # Load only specified environment from config
    def env
      @env ||= begin
        e = ENV["TEST_ENV"]
        e = DEFAULT_ENV if e == "" || e.nil?
        StringInquirer.new(e)
      end
    end
  end
end
