# typed: false
# frozen_string_literal: true

require "simple_cache_lock/client"
require "redis"

RSpec.describe SimpleCacheLock::Client do
  def run_parallel(times, &block)
    threads = Array.new(times).map do
      Thread.new do
        block.call
      end
    end

    threads.map(&:join)
  end

  subject :client do
    SimpleCacheLock.configure do |config|
      config.redis_urls = ["redis://localhost:6379"]
      config.cache_store = cache_store
      config.default_lock_timeout = 100
      config.default_wait_lock_timeout = 100
      config.default_wait_timeout = 5
    end
    described_class.new
  end

  let(:cache_store) { Redis.new }

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

    context "when cache key is locked and exceeding time out" do
      it "raise error" do # rubocop:disable RSpec/ExampleLength
        expect do
          run_parallel(3) do
            client.lock("a", "b", lock_timeout: 2, wait_timeout: 2, wait_lock_timeout: 2) do
              sleep 5

              "foo"
            end
          end
        end.to raise_error(SimpleCacheLock::Error)
      end
    end

    context "when there are multiple lock called to the same cache key" do
      it "writes the cache only once" do # rubocop:disable RSpec/ExampleLength
        # rubocop:disable RSpec/MessageSpies
        # rubocop:disable RSpec/SubjectStub
        expect(client).to receive(:write_data).once.and_call_original
        # rubocop:enable RSpec/MessageSpies
        # rubocop:enable RSpec/SubjectStub

        run_parallel(3) do
          client.lock("a", "b") do
            sleep 1

            "foo"
          end
        end
      end
    end
  end
end
