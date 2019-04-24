RSpec.describe SimpleCacheLock::Client do
  custom_cache_store = Class.new do
    def initialize
      @store = {}
    end
    def read(key)
      @store[key]
    end

    def write(key, value)
      @store[key] = value
    end

    def exist?(key)
      @store.key? key
    end
  end

  subject do
    SimpleCacheLock.configure do |config|
      config.redis_urls = ['redis://localhost:6379']
      config.cache_store = custom_cache_store.new
    end
    described_class.new
  end

  describe 'lock' do
    it do
      lock_key = 'foo'
      content_cache_key = 'bar'
      foo = subject.lock(lock_key, content_cache_key) do
        'bar'
      end
      expect(foo).to eq('bar')
    end
  end
end
