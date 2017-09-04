# frozen_string_literal: true

module ClockworkMocks
  class ClockworkTask
    def initialize(interval, name, hash, block)
      @interval = interval
      @name = name
      @hash = hash
      @block = block

      @due = calc_due
    end

    def reset!
      @due = Time.now
      @due = calc_due
    end

    def perform
      @block.call
      @due = calc_due
    end

    attr_reader :due

    private

    def calc_due
      due = Time.at((due || Time.now).to_f + @interval)

      return due unless @hash[:at]

      at_split = @hash[:at].split(':').map(&:to_i)
      new_due = due.change(hour: at_split[0], minute: at_split[1])

      new_due < due ? new_due : (new_due - 1.day)
    end
  end
end
