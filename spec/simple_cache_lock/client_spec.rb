# typed: false
# frozen_string_literal: true

require "simple_cache_lock/client"
require "mock_redis"

RSpec.describe SimpleCacheLock::Client do
  subject :client do
    SimpleCacheLock.configure do |config|
      config.redis_urls = ["redis://localhost:6379"]
      config.cache_store = MockRedis.new
    end
    described_class.new
  end

  describe "#lock" do
    it "write the cache" do
      expected = "baz"
      foo = client.lock("key-123", "bar") do
        expected
      end
      expect(foo).to eq(expected)
    end
  end
end
