# frozen_string_literal: true

module ClockworkMocks
  class Scheduler
    attr_reader :tasks

    def initialize
      @tasks = []
    end

    def self.init_rspec(allow, receive, clock_file = nil, &block)
      Scheduler.new.tap { |s| s.init_rspec(allow, receive, clock_file, &block) }
    end

    def init_rspec(allow, receive, clock_file = nil)
      allow.call(Clockwork).to receive.call(:handler) do |&block|
        handler(&block)
      end

      allow.call(Clockwork).to receive.call(:every) do |interval, name, hash, &block|
        every interval, name, hash, &block
      end

      if block_given?
        yield
      else
        unless clock_file
          rails = Object.const_get('Rails')
          clock_file = "#{rails.root}/clock.rb" if rails
        end

        load clock_file if clock_file
      end
    end

    def work
      loop do
        t = @tasks.min_by(&:due)

        break if t.nil? || t.due > Time.now

        t.perform(@handler)
      end
    end

    def reset!
      @tasks.each(&:reset!)
    end

    def handler(&block)
      return @handler unless block_given?
      @handler = block
    end

    def every(interval, name, hash = {}, &block)
      @tasks.push ClockworkTask.new(interval, name, hash, block)
    end
  end
end
