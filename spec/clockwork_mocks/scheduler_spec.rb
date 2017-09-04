# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClockworkMocks::Scheduler do
  before { Timecop.freeze(2017, 8, 10, 20, 0) }
  after { Timecop.return }
  subject { described_class.new }

  let(:task1) do
    d = instance_double(Proc)
    allow(d).to receive(:call)
    d
  end

  describe '.init_rspec' do
    let(:init_block) { -> { Clockwork.every(1.day, 'some task') { task1.call } } }
    subject { described_class.init_rspec(->(a) { allow a }, ->(a) { receive a }) { init_block.call } }

    it 'automagically adds the task' do
      expect(subject.tasks).not_to be_empty
    end
  end

  describe '#work' do
    before { subject.every(1.day, 'some task') { task1.call } }

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

    context 'with a second task' do
      let(:result) { [] }
      let(:task1) { -> { result.push 1 } }
      let(:task2) { -> { result.push 2 } }
      before { subject.every(2.days, 'another task') { task2.call } }
      before { Timecop.freeze 3.days.from_now }

      it 'executes the tasks in order' do
        subject.work
        expect(result).to eq([1, 1, 2, 1])
      end
    end
  end
end
