# frozen_string_literal: true

class SuggestQuestion
  API_HOST             = 'https://fv4gjddr9a.execute-api.us-east-2.amazonaws.com'
  SUGGEST_QUESTION_URL = 'Prod'

  def call
    question = Question.new(title: data['question'])
    answers  = data['answers'].map { |answer| Answer.new(title: answer['body'], is_correct: answer['correct']) }

    { question: question, answers: answers }
  end

  private

  def data
    @data ||= begin
      JSON.parse(response.body)
    rescue JSON::ParserError
      {}
    end
  end

  def response
    conn.get(SUGGEST_QUESTION_URL)
  end

  def conn
    Faraday.new(API_HOST)
  end
end
