require "gem_config"
require "redlock"
require "simple_cache_lock/client"
require "simple_cache_lock/version"

module SimpleCacheLock
  include GemConfig::Base

  class Error < StandardError; end

  with_configuration do
    has :redis_urls, classes: Array, default: []
    has :cache_store
  end
end
