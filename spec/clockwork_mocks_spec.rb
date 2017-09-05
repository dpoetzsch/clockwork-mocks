# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClockworkMocks do
  context 'static singleton usage' do
    before { ClockworkMocks.reset! }

    describe '.scheduler' do
      it 'creates a scheduler' do
        expect(ClockworkMocks.scheduler).to be_present
      end

      it 'is a singleton' do
        expect(ClockworkMocks.scheduler).to be(ClockworkMocks.scheduler)
      end
    end

    describe '.rspec_init' do
      it 'automagically collects the tasks' do
        ClockworkMocks.init_rspec(method(:allow), method(:receive)) do
          Clockwork.every 1.day, 'foo'
        end
        expect(ClockworkMocks.scheduler.tasks.map(&:name)).to include('foo')
      end
    end

    describe '.reset!' do
      it 'calls through to Scheduler#reset!' do
        expect(ClockworkMocks.scheduler).to receive(:reset!)
        ClockworkMocks.reset!
      end
    end

    describe '.work' do
      it 'calls through to Scheduler#work' do
        expect(ClockworkMocks.scheduler).to receive(:work)
        ClockworkMocks.work
      end
    end
  end
end
