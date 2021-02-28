# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuggestQuestion, type: :service do
  describe '#call' do
    let(:question_title) { 'foo' }
    let(:correct_answer_title) { 'fizz' }
    let(:incorrect_answer_title) { 'buzz' }

    before do
      stub_request(:get, "#{SuggestQuestion::API_HOST}/#{SuggestQuestion::SUGGEST_QUESTION_URL}")
        .to_return(body: {
          question: question_title,
          answers: [{ body: correct_answer_title, correct: true },
                    { body: incorrect_answer_title, correct: false }]
        }.to_json)
    end

    subject { described_class.new.call }

    it 'returns the expected data' do
      data = subject

      expect(data[:question]).to be_a(Question)
      expect(data[:question].title).to eq(question_title)

      expect(data[:answers].first).to be_a(Answer)
      expect(data[:answers].first.title).to eq(correct_answer_title)
      expect(data[:answers].first.is_correct).to eq(true)

      expect(data[:answers].second).to be_a(Answer)
      expect(data[:answers].second.title).to eq(incorrect_answer_title)
      expect(data[:answers].second.is_correct).to eq(false)
    end
  end
end
