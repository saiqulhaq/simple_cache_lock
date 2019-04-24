require "simple_cache_lock/version"
require "gem_config"
require "redlock"

module SimpleCacheLock
  include GemConfig::Base

  class Error < StandardError; end

  def self.redlock
    @redlock ||= Redlock::Client.new(configuration.redis_urls)
  end

  with_configuration do
    has :redis_urls, classes: Array, default: []
    has :cache_store
  end

  after_configuration_change do
    @redlock = Redlock::Client.new(configuration.redis_urls)
  end
end
