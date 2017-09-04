# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClockworkMocks::Scheduler do
  before { Timecop.freeze(2017, 8, 10, 20, 0) }
  after { Timecop.return }
  subject! { described_class.new(->(a) { allow a }, ->(a) { receive a }) { init_block.call } }

  describe '#work' do
    let(:task1) { instance_double(Proc) }
    before { allow(task1).to receive(:call) }
    let(:init_block) { -> { Clockwork.every(1.day, 'some task') { task1.call } } }

    context 'task is not due' do
      it 'does not perform the task' do
        subject.work
        expect(task1).not_to have_received(:call)
      end
    end

    context 'task is due' do
      before { Timecop.freeze 1.day.from_now }
      it 'performs the task once' do
        subject.work
        expect(task1).to have_received(:call).once
      end
    end

    context 'task is due twice' do
      before { Timecop.freeze 2.days.from_now }
      it 'performs the task twice' do
        subject.work
        expect(task1).to have_received(:call).twice
      end
    end
  end
end
