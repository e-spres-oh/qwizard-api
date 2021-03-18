# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PlayerAnswersAPI', type: :request do
  describe 'index' do
    subject { get api_v1_player_answers_path }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current lobbies' do
      quiz = Quiz.create(title: 'quiz')
      question = Question.create(title: 'question', time_limit: 30, points: 1, answer_type: 'single', order: 100, quiz: quiz)
      answer = Answer.create(title: 'answer', is_correct: true, question: question)
      lobby = Lobby.create(code: 'lobby', status: 'pending', quiz: quiz)
      player_one = Player.create(name: 'player_one', hat: 'star', lobby: lobby)
      player_two = Player.create(name: 'player_two', hat: 'star', lobby: lobby)
      player_one_answer = PlayerAnswer.create(answer: answer, player: player_one)
      player_two_answer = PlayerAnswer.create(answer: answer, player: player_two)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([player_one_answer, player_two_answer].as_json)
    end
  end

  describe 'create' do
    let(:quiz) { Quiz.create(title: 'quiz') }
    let(:question) { Question.create(title: 'question', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz) }
    let(:answer) { Answer.create(title: 'answer', is_correct: true, question: question) }
    let(:lobby) { Lobby.create(code: 'lobby', status: 'pending', quiz: quiz) }
    let(:player) { Player.create(name: 'player', hat: 'star', lobby: lobby) }
    let(:player_answer_params) do
      { player_id: player.id, answer_id: answer.id }
    end

    subject { post api_v1_player_answers_path, params: { player_answer: player_answer_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a PlayerAnswer model with the request params' do
      subject

      player_answer = PlayerAnswer.last

      expect(player_answer.player).to eq(player)
      expect(player_answer.answer).to eq(answer)
    end

    it 'responds with the created PlayerAnswer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(PlayerAnswer.last.as_json)
    end

    context 'invalid parameters' do
      let(:player_answer_params) do
        { player_id: player.id }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'answer', error: 'blank', message: 'must exist' }])
      end
    end
  end

  describe 'show' do
    let(:quiz) { Quiz.create(title: 'quiz') }
    let(:question) { Question.create(title: 'question', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz) }
    let(:answer) { Answer.create(title: 'answer', is_correct: true, question: question) }
    let(:lobby) { Lobby.create(code: 'lobby', status: 'pending', quiz: quiz) }
    let(:player) { Player.create(name: 'player', hat: 'star', lobby: lobby) }
    let(:player_answer) { PlayerAnswer.create(player: player, answer: answer) }

    subject { get api_v1_player_answer_path(id: player_answer.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested PlayerAnswer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player_answer.as_json)
    end
  end

  describe 'update' do
    let(:quiz) { Quiz.create(title: 'quiz') }
    let(:question) { Question.create(title: 'question', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz) }
    let(:answer) { Answer.create(title: 'answer', is_correct: true, question: question) }
    let(:new_answer) { Answer.create(title: 'new_answer', is_correct: false, question: question) }
    let(:lobby) { Lobby.create(code: 'lobby', status: 'pending', quiz: quiz) }
    let(:player) { Player.create(name: 'player', hat: 'star', lobby: lobby) }
    let(:player_answer) { PlayerAnswer.create(player: player, answer: answer) }
    let(:player_answer_params) do
      { answer_id: new_answer.id }
    end
    subject { put api_v1_player_answer_path(id: player_answer.id), params: { player_answer: player_answer_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the PlayerAnswer attributes' do
      subject

      expect(player_answer.reload.answer).to eq(new_answer)
    end

    it 'responds with the updated PlayerAnswer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player_answer.reload.as_json)
    end
  end

  describe 'destroy' do
    let(:quiz) { Quiz.create(title: 'quiz') }
    let(:question) { Question.create(title: 'question', time_limit: 30, points: 100, answer_type: 'single', order: 1, quiz: quiz) }
    let(:answer) { Answer.create(title: 'answer', is_correct: true, question: question) }
    let(:lobby) { Lobby.create(code: 'lobby', status: 'pending', quiz: quiz) }
    let(:player) { Player.create(name: 'player', hat: 'star', lobby: lobby) }
    let(:player_answer) { PlayerAnswer.create(player: player, answer: answer) }

    subject { delete api_v1_player_answer_path(id: player_answer.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the PlayerAnswer model' do
      subject

      expect { player_answer.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed PlayerAnswer model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(player_answer.as_json)
    end
  end
end
