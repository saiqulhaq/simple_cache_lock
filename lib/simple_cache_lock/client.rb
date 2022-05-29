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
      is_locked = redlock.lock(lock_key, lock_timeout)

      if is_locked == false
        Timeout.timeout(wait_timeout) do
          loop do
            is_locked = redlock.lock(lock_key, wait_lock_timeout)
            break unless is_locked == false

            sleep rand
          end
        end

        if cache_store.exists? content_cache_key
          redlock.unlock(is_locked) unless is_locked
          return cache_store.get key
        end
      end

      result = block.call
      cache_store.set content_cache_key, result
      redlock.unlock(is_locked)
      result
    rescue Redlock::LockError, Timeout::Error => e
      raise SimpleCacheLock::Error, e
    end

    private

    def cache_store
      SimpleCacheLock.configuration.cache_store
    end

    def redlock
      @redlock ||= Redlock::Client.new(SimpleCacheLock.configuration.redis_urls)
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
  end
end
