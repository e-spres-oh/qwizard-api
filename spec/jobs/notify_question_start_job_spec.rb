# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyQuestionStartJob, type: :job do
  describe 'perform' do
    let(:quiz) { FactoryBot.create(:quiz) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }
    let(:player) { FactoryBot.create(:player, lobby: lobby) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }

    before do
      allow(Pusher).to receive(:trigger)
    end

    subject { described_class.perform_now(lobby_id: lobby.id, question_index: question.order) }

    it 'triggers a QUESTION_START Pusher event' do
      subject

      expect(Pusher).to have_received(:trigger).with(lobby.code, Lobby::QUESTION_START, { question_index: question.order })
    end

    it 'updates the lobby current_question_index to the current question\'s order' do
      question.update(order: 2)

      subject

      expect(lobby.reload.current_question_index).to eq(question.order)
    end
  end
end
