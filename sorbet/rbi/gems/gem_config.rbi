# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/gem_config/all/gem_config.rbi
#
# gem_config-0.3.2

module GemConfig
end
class GemConfig::Rules < Hash
  def check(key, value); end
  def check_attributes(attrs); end
  def has(key, attrs = nil); end
end
class GemConfig::Configuration
  def call_after_configuration_change; end
  def current; end
  def get(key); end
  def initialize(parent = nil); end
  def method_missing(method, *args, &block); end
  def reset; end
  def rules; end
  def set(key, value); end
  def unset(key); end
end
module GemConfig::Base
  def self.included(base); end
end
module GemConfig::Base::ClassMethods
  def after_configuration_change(&block); end
  def configuration; end
  def configure; end
  def with_configuration(&block); end
end
class GemConfig::InvalidKeyError < StandardError
end
