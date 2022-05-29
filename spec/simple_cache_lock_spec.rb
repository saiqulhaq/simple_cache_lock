# frozen_string_literal: true

require "simple_cache_lock"

RSpec.describe SimpleCacheLock do
  it "has a version number" do
    expect(SimpleCacheLock::VERSION).not_to be nil
  end

  describe "configuration" do
    it "can change redis_urls" do
      urls = []
      described_class.configuration.redis_urls = urls
      expect(described_class.configuration.redis_urls).to be_empty
      urls = ["redis://redis:6379", "redis://redis:6380"]
      described_class.configuration.redis_urls = urls
      expect(described_class.configuration.redis_urls).to eq(urls)
    end
  end
end
