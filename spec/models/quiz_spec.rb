# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz, type: :model do
  it 'is valid if title present' do
    quiz = described_class.new(title: 'test')
    expect(quiz).to be_valid
  end

  it 'is invalid if title missing' do
    quiz = described_class.new
    expect(quiz).not_to be_valid
  end
end
