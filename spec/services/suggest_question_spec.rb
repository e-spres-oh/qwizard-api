# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuggestQuestion, type: :service do
  describe '#call' do
    subject { described_class.new.call }

    it 'returns the expected data' do
      data = subject
      expect(data[:question]).to be_a(Question)
      data[:answers].each { |answer| expect(answer).to be_a(Answer) }
    end
  end
end
