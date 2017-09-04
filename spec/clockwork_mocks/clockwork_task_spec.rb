# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Clockwork::Mocks do
  it 'has a version number' do
    expect(Clockwork::Mocks::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
