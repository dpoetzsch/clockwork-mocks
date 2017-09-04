# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClockworkMocks::ClockworkTask do
  let(:interval) { 1.day }
  let(:name) { 'some name' }
  let(:hash) { {} }
  let(:block) { instance_double(Proc) }
  before { Timecop.freeze(2017, 8, 10, 20, 0) }
  after { Timecop.return }
  subject { described_class.new(interval, name, hash, block) }
  before { allow(block).to receive(:call) }

  describe '#perform' do
    context 'without handler' do
      before { subject.perform }

      it 'calls the passed proc' do
        expect(block).to have_received(:call)
      end

      it 'recalculates due date' do
        expect(subject.due).to eq(2.days.from_now)
      end
    end

    context 'with handler' do
      let(:handler) { instance_double(Proc) }
      before { allow(handler).to receive(:call) }
      before { subject.perform(->(j, t) { handler.call(j, t) }) }

      context 'with individual proc' do
        it 'calls the individual proc' do
          expect(block).to have_received(:call)
        end
      end

      context 'without individual proc' do
        let(:block) { nil }

        it 'calls the handler' do
          expect(handler).to have_received(:call)
        end
      end
    end
  end

  describe '#reset!' do
    before do
      subject.perform
      subject.reset!
    end

    it 'resets the due date' do
      expect(subject.due).to eq(1.day.from_now)
    end
  end

  describe 'due date calculation' do
    context '1 day interval' do
      context 'no at given' do
        it 'schedules the due date tomorrow' do
          expect(subject.due).to eq(interval.from_now)
        end
      end

      context 'at is still today' do
        let(:hash) { { at: '23:00' } }

        it 'schedules the due date for today' do
          expect(subject.due).to eq(Time.new(2017, 8, 10, 23, 0))
        end
      end

      context 'at is tomorrow' do
        let(:hash) { { at: '02:00' } }

        it 'schedules the due date for tomorrow' do
          expect(subject.due).to eq(Time.new(2017, 8, 11, 2, 0))
        end
      end
    end
  end
end
