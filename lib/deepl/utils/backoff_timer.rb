# frozen_string_literal: true

module DeepL
  module Utils
    class BackoffTimer
      # Implements exponential-backoff strategy.
      # This strategy is based on the GRPC Connection Backoff Protocol:
      # https://github.com/grpc/grpc/blob/master/doc/connection-backoff.md

      BACKOFF_INITIAL = 1.0
      BACKOFF_MAX = 120.0
      BACKOFF_JITTER = 0.23
      BACKOFF_MULTIPLIER = 1.6

      attr_reader :num_retries

      def initialize(min_connection_timeout = 10.0)
        @num_retries = 0
        @backoff = BACKOFF_INITIAL
        @deadline = Time.now.to_f + @backoff
        @min_connection_timeout = min_connection_timeout
      end

      def current_request_timeout
        [time_until_deadline, @min_connection_timeout].max
      end

      def time_until_deadline
        [@deadline - Time.now.to_f, 0.0].max
      end

      def sleep_until_deadline
        sleep(time_until_deadline)
        # Apply multiplier to current backoff time
        @backoff = [@backoff * BACKOFF_MULTIPLIER, BACKOFF_MAX].min
        # Get deadline by applying jitter as a proportion of backoff:
        # if jitter is 0.1, then multiply backoff by random value in [0.9, 1.1]
        @deadline = Time.now.to_f + (@backoff * (1 + (BACKOFF_JITTER * rand(-1.0..1.0))))
        @num_retries += 1
      end
    end
  end
end
