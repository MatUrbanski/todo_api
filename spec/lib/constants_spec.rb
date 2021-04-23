# frozen_string_literal: true

require 'spec_helper'

describe Constants do
  it 'defines EMAIL_REGEX constant' do
    expect(described_class::EMAIL_REGEX).to eq(/^[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+$/)
  end

  it 'defines SORT_DIRECTIONS constant' do
    expect(described_class::SORT_DIRECTIONS).to eq %w[desc asc]
  end

  it 'defines TODO_SORT_COLUMNS constant' do
    expect(described_class::TODO_SORT_COLUMNS).to eq %w[name description created_at updated_at]
  end

  it 'defines UUID_REGEX constant' do
    expect(described_class::UUID_REGEX).to eq(/(\h{8}(?:-\h{4}){3}-\h{12})/)
  end
end
