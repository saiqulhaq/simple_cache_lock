# typed: false
# frozen_string_literal: true

require "simple_cache_lock/client"
require "mock_redis"

RSpec.describe SimpleCacheLock::Client do
  subject :client do
    SimpleCacheLock.configure do |config|
      config.redis_urls = ["redis://localhost:6379"]
      config.cache_store = cache_store
      config.default_wait_timeout = 1
    end
    described_class.new
  end

  let(:cache_store) { MockRedis.new }

  describe "#lock" do
    context "when the cache is exist" do
      it "will read the data from redis directly" do
        cached_value = "foo"
        client.lock("lock_key", "cache_key") { cached_value }
        allow(cache_store).to receive(:set).and_raise

        expected = client.lock("lock_key", "cache_key") { "1232" }
        expect(expected).to eq(cached_value)
      end
    end

    context "when the cache is not exist" do
      it "write the cache" do
        expected = "baz"
        foo = client.lock("key-123", "bar") do
          expected
        end
        expect(foo).to eq(expected)
      end
    end

    # xcontext "when cache key is not locked" do
    # end

    # context "when cache key is locked" do
    #   context "when there is another process writing the same key" do
    #     it "will wait and read the key instead" do
    #     end
    #   end

    #   context "when there is no another process writing the same key" do
    #     it "will"
    #   end
    # end
  end
end
