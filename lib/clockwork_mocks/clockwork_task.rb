# frozen_string_literal: true

module ClockworkMocks
  class ClockworkTask
    def initialize(interval, name, hash, block)
      @interval = interval
      @name = name
      @hash = hash || {}
      @block = block

      @due = calc_due
    end

    def reset!
      @due = Time.now
      @due = calc_due
    end

    def perform(handler = nil)
      if @block
        @block.call
      elsif handler
        handler.call(@name, Time.now)
      end
      @due = calc_due
    end

    attr_reader :due, :name

    private

    def calc_due
      ndue = Time.at((due || Time.now).to_f + @interval)

      return ndue unless @hash[:at]

      at_split = @hash[:at].split(':').map(&:to_i)
      new_due = ndue.change(hour: at_split[0], minute: at_split[1])

      new_due <= ndue ? new_due : (new_due - 1.day)
    end
  end
end
