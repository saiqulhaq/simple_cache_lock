# frozen_string_literal: true

require "simple_cache_lock"

RSpec.describe SimpleCacheLock do
  it "has a version number" do
    expect(SimpleCacheLock::VERSION).not_to be_nil
  end

  describe ".configuration" do
    describe ".redis_urls" do
      it "returns empty array if empty array is given" do
        described_class.configuration.redis_urls = []
        expect(described_class.configuration.redis_urls).to be_empty
      end

      it "returns correct data when given parameter is correct" do
        urls = ["redis://redis:6379", "redis://redis:6380"]
        described_class.configuration.redis_urls = urls
        expect(described_class.configuration.redis_urls).to eq(urls)
      end
    end
  end
end
