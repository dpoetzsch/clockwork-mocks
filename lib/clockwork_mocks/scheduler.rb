# frozen_string_literal: true

module ClockworkMocks
  class Scheduler
    def initialize(allow, receive)
      @tasks = []

      allow.call(Clockwork).to receive.call(:every) do |interval, name, hash, &block|
        @tasks.push ClockworkTask.new(interval, name, hash, block)
      end

      if block_given?
        yield
      else
        load "#{Rails.root}/clock.rb"
      end
    end

    def work
      loop do
        t = @tasks.min_by(&:due)

        break if t.nil? || t.due > Time.now

        t.perform
      end
    end

    def reset!
      @tasks.each(&:reset!)
    end
  end
end
