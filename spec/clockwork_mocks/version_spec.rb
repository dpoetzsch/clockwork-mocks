# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Clockwork::Mocks do
  it 'has a version number' do
    expect(ClockworkMocks::Mocks::VERSION).not_to be nil
  end
end
