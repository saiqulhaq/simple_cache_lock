# typed: false
# frozen_string_literal: true

require "timeout"

module SimpleCacheLock
  class Client
    # @param lock_key [String]
    # @param content_cache_key [String]
    # @param options [Hash]
    #   lock_timeout [Integer]
    #   wait_timeout [Integer]
    #   wait_lock_timeout [Integer] optional
    def lock(lock_key, content_cache_key, options = {}, &block)
      return cache_store.get content_cache_key if cache_store.exists? content_cache_key

      @options = options
      is_locked = locker.lock(lock_key, lock_timeout)

      if is_locked == false
        Timeout.timeout(wait_timeout) do
          index = 0
          loop do
            puts "hello #{index}"
            index += 1
            is_locked = locker.lock(lock_key, wait_lock_timeout)
            break unless is_locked == false

            sleep 1
          end
        end

        if cache_store.exists? content_cache_key
          locker.unlock(is_locked) unless is_locked
          return cache_store.get content_cache_key
        end
      end

      content = block.call
      write_data content_cache_key, content
      locker.unlock(is_locked)
      content
    rescue Redlock::LockError, Timeout::Error => e
      raise SimpleCacheLock::Error, e
    end

    private

    def cache_store
      SimpleCacheLock.configuration.cache_store
    end

    def locker
      @locker ||= Redlock::Client.new(SimpleCacheLock.configuration.redis_urls, {
        # retry_count:   0,
        # retry_delay:   200, # milliseconds
        # retry_jitter:  50,  # milliseconds
        # redis_timeout: 0.1  # seconds
      })
    end

    def lock_timeout
      @options[:initial_lock_timeout] || SimpleCacheLock.configuration.default_lock_timeout
    end

    def wait_lock_timeout
      @options[:wait_lock_timeout] || SimpleCacheLock.configuration.default_wait_lock_timeout
    end

    def wait_timeout
      @options[:wait_timeout] || SimpleCacheLock.configuration.default_wait_timeout
    end

    def write_data(content_cache_key, content)
      cache_store.set content_cache_key, content
    end
  end
end
