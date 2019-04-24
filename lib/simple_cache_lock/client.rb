require 'timeout'

module SimpleCacheLock
  class Client
    # @param lock_key [String]
    # @param content_cache_key [String]
    # @param options [Hash]
    #   lock_timeout [Integer]
    #   wait_timeout [Integer]
    #   wait_lock_timeout [Integer] optional
    def lock(lock_key, content_cache_key, options = {}, &block)
      return cache_store.read content_cache_key if cache_store.exist? content_cache_key

      @options = options
      is_locked = redlock.lock(lock_key, lock_timeout)

      if is_locked == false
        Timeout::timeout(wait_timeout) {
          while is_locked = redlock.lock(lock_key, wait_lock_timeout) == false
            sleep rand
          end
        }

        if cache_store.exist? content_cache_key
          redlock.unlock(is_locked)
          return cache_store.read key
        end
      end

      result = block.call
      cache_store.write content_cache_key, result
      redlock.unlock(is_locked)
      result
    rescue Redlock::LockError, Timeout::Error => error
      raise SimpleCacheLock::Error, error
    end

    private

    def cache_store
      SimpleCacheLock.configuration.cache_store
    end

    def redlock
      @redlock ||= Redlock::Client.new(SimpleCacheLock.configuration.redis_urls)
    end


    def lock_timeout
      @options[:initial_lock_timeout] || 10000
    end

    def wait_timeout
      @options[:wait_timeout] || 40000
    end

    def wait_lock_timeout
      @options[:wait_lock_timeout] || wait_timeout
    end
  end
end
