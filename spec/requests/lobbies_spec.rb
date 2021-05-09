# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LobbiesAPI', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before { post api_v1_login_path, params: { user: { username: user.username, password: user.password } } }

  describe 'index' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }

    subject { get api_v1_quiz_lobbies_path(quiz_id: quiz.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the current lobbies' do
      foo_lobby = FactoryBot.create(:lobby, quiz: quiz)
      bar_lobby = FactoryBot.create(:lobby, quiz: quiz)

      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([foo_lobby, bar_lobby].map { |q| q.as_json.merge('quiz_master' => quiz.user.username) })
    end
  end

  describe 'create' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby_params) do
      { status: 'pending', current_question_index: 2 }
    end

    subject { post api_v1_quiz_lobbies_path(quiz_id: quiz.id), params: { lobby: lobby_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a Lobby model with the request params' do
      subject

      lobby = Lobby.last

      expect(lobby.code).to be_present
      expect(lobby.status).to eq(lobby_params[:status])
      expect(lobby.current_question_index).to eq(2)
      expect(lobby.quiz).to eq(quiz)
    end

    it 'responds with the created Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Lobby.last.as_json.merge('quiz_master' => quiz.user.username))
    end

    context 'invalid parameters' do
      let(:lobby_params) do
        { code: 'foo' }
      end

      it 'responds with unprocessable_entity HTTP status' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with errors list' do
        subject

        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response).to eq(errors: [{ attribute: 'status', error: 'blank', message: 'can\'t be blank' }])
      end
    end
  end

  describe 'show' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }

    subject { get api_v1_lobby_path(id: lobby.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end
  end

  describe 'update' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }
    let(:lobby_params) do
      { status: 'in_progress' }
    end
    subject { put api_v1_lobby_path(id: lobby.id), params: { lobby: lobby_params } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'updates the Lobby attributes' do
      subject

      expect(lobby.reload.status).to eq('in_progress')
    end

    it 'responds with the updated Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.reload.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end
  end

  describe 'destroy' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }

    subject { delete api_v1_lobby_path(id: lobby.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'destroys the Lobby model' do
      subject

      expect { lobby.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'responds with the destroyed Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end
  end

  describe 'from_code' do
    let(:lobby) { FactoryBot.create(:lobby) }
    let(:lobby_code) { lobby.code }

    subject { get api_v1_lobby_from_code_path(code: lobby_code) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the requested Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end

    context 'lobby not found' do
      let(:lobby_code) { 'nonexistent' }

      it 'responds with not found HTTP status' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'join' do
    let(:lobby) { FactoryBot.create(:lobby) }
    let(:player_params) do
      { name: 'foo', hat: 'star' }
    end

    before do
      allow(Pusher).to receive(:trigger)
    end

    subject { post join_api_v1_lobby_path(id: lobby.id), params: { player: player_params } }

    it 'responds with created HTTP status' do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'creates a new Player model with the request params' do
      subject

      player = Player.last

      expect(player.name).to eq(player_params[:name])
      expect(player.hat).to eq(player_params[:hat])
      expect(player.lobby).to eq(lobby)
    end

    it 'responds with the created Player model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(Player.last.as_json)
    end

    it 'triggers a PLAYER_JOINED Pusher event' do
      subject

      expect(Pusher).to have_received(:trigger).with(lobby.code, Lobby::PLAYER_JOIN, { id: Player.last.id })
    end
  end

  describe 'start' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }
    let(:question1) { FactoryBot.create(:question, quiz: quiz) }
    let(:question2) { FactoryBot.create(:question, quiz: quiz) }
    let(:question3) { FactoryBot.create(:question, quiz: quiz) }

    before do
      allow(Pusher).to receive(:trigger)
      question1
      question2
      question3
    end

    subject { post start_api_v1_lobby_path(id: lobby.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'sets the Lobby status to in_progress' do
      subject

      expect(lobby.reload.status).to eq('in_progress')
    end

    it 'responds with the started Lobby model' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(lobby.reload.as_json.merge('quiz_master' => lobby.quiz.user.username))
    end

    it 'triggers a LOBBY_START Pusher event' do
      subject

      expect(Pusher).to have_received(:trigger).with(lobby.code, Lobby::LOBBY_START, {})
    end
  end

  describe 'answer' do
    let(:quiz) { FactoryBot.create(:quiz) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }
    let(:player) { FactoryBot.create(:player, lobby: lobby) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }
    let(:answer1) { FactoryBot.create(:answer, question: question) }
    let(:answer2) { FactoryBot.create(:answer, question: question) }

    before do
      allow(Pusher).to receive(:trigger)
    end

    subject { post answer_api_v1_lobby_path(id: lobby.id), params: { player_id: player.id, answers: [answer1.id, answer2.id] } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'creates PlayerAnswer models for the specified request params' do
      subject

      expect(PlayerAnswer.find_by(player: player, answer: answer1)).to be_present
      expect(PlayerAnswer.find_by(player: player, answer: answer2)).to be_present
    end

    it 'responds with the question\'s answers' do
      subject

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(question.answers.as_json)
    end

    it 'triggers a ANSWER_SENT Pusher event' do
      subject

      expect(Pusher).to have_received(:trigger).with(lobby.code, Lobby::ANSWER_SENT, { answer_count: 1 })
    end

    context 'existing answers' do
      before { FactoryBot.create(:player_answer, player: player, answer: answer1) }

      subject { post answer_api_v1_lobby_path(id: lobby.id), params: { player_id: player.id, answers: [answer2.id] } }

      it 'responds with successful HTTP status' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'creates PlayerAnswer models for the specified request params' do
        subject

        expect(PlayerAnswer.find_by(player: player, answer: answer2)).to be_present
      end

      it 'removes PlayerAnswer models which are no longer present in the request params' do
        subject

        expect(PlayerAnswer.find_by(player: player, answer: answer1)).to_not be_present
      end
    end
  end

  describe 'players_done' do
    let(:quiz) { FactoryBot.create(:quiz) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }

    let(:player1) { FactoryBot.create(:player, lobby: lobby) }
    let(:player2) { FactoryBot.create(:player, lobby: lobby) }
    let(:player3) { FactoryBot.create(:player, lobby: lobby) }

    let(:answer1) { FactoryBot.create(:answer, question: question) }
    let(:answer2) { FactoryBot.create(:answer, question: question) }
    let(:answer3) { FactoryBot.create(:answer, question: question) }

    let(:player_answer1) { FactoryBot.create(:player_answer, answer: answer1, player: player1) }
    let(:player_answer2) { FactoryBot.create(:player_answer, answer: answer2, player: player2) }
    let(:player_answer3) { FactoryBot.create(:player_answer, answer: answer3, player: player3) }

    before do
      player_answer1
      player_answer2
      player_answer3
    end

    subject { post players_done_api_v1_lobby_path(id: lobby.id), params: { question_id: question.id } }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the question\'s players' do
      subject

      players = [player1, player2, player3]
      expect(JSON.parse(response.body)).to eq(players.as_json)
    end
  end

  describe 'score' do
    let(:quiz) { FactoryBot.create(:quiz) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }
    let(:question1) { FactoryBot.create(:question, quiz: quiz, points: 100, answer_type: 'single') }
    let(:question2) { FactoryBot.create(:question, quiz: quiz, points: 200, answer_type: 'multiple') }

    let(:player1) { FactoryBot.create(:player, lobby: lobby) }
    let(:player2) { FactoryBot.create(:player, lobby: lobby) }
    let(:player3) { FactoryBot.create(:player, lobby: lobby) }

    let(:answer1) { FactoryBot.create(:answer, question: question1, is_correct: true) }
    let(:answer2) { FactoryBot.create(:answer, question: question1, is_correct: false) }
    let(:answer3) { FactoryBot.create(:answer, question: question1, is_correct: false) }

    let(:answer4) { FactoryBot.create(:answer, question: question2, is_correct: false) }
    let(:answer5) { FactoryBot.create(:answer, question: question2, is_correct: true) }
    let(:answer6) { FactoryBot.create(:answer, question: question2, is_correct: true) }

    let(:player_answer1) { FactoryBot.create(:player_answer, answer: answer1, player: player1) }
    let(:player_answer2) { FactoryBot.create(:player_answer, answer: answer2, player: player2) }
    let(:player_answer3) { FactoryBot.create(:player_answer, answer: answer3, player: player3) }

    let(:player_answer4) { FactoryBot.create(:player_answer, answer: answer4, player: player1) }
    let(:player_answer5) { FactoryBot.create(:player_answer, answer: answer5, player: player2) }
    let(:player_answer6) { FactoryBot.create(:player_answer, answer: answer5, player: player3) }
    let(:player_answer7) { FactoryBot.create(:player_answer, answer: answer6, player: player3) }

    before do
      player_answer1
      player_answer2
      player_answer3
      player_answer4
      player_answer5
      player_answer6
      player_answer7
    end

    subject { get score_api_v1_lobby_path(id: lobby.id) }

    it 'responds with successful HTTP status' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'responds with the score' do
      subject

      score = [
        { name: player1.name, hat: player1.hat, points: 100 },
        { name: player2.name, hat: player2.hat, points: 0 },
        { name: player3.name, hat: player3.hat, points: 200 }
      ]

      expect(JSON.parse(response.body)).to eq(score.as_json)
    end
  end
end
