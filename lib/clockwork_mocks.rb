# frozen_string_literal: true

require 'clockwork'

require 'clockwork_mocks/version'
require 'clockwork_mocks/clockwork_task'
require 'clockwork_mocks/scheduler'

module ClockworkMocks
  def self.init_rspec(allow, receive, clock_file = nil, &block)
    scheduler.init_rspec(allow, receive, clock_file, &block)
  end

  def self.reset_rspec(allow, receive, clock_file = nil, &block)
    if scheduler.tasks.empty?
      init_rspec(allow, receive, clock_file, &block)
    else
      reset!
    end
  end

  def self.scheduler
    @scheduler ||= Scheduler.new
  end

  def self.reset!
    scheduler.reset!
  end

  def self.reset_scheduler_instance!
    @scheduler = nil
  end

  def self.work
    scheduler.work
  end
end
