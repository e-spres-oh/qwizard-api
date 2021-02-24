# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyQuestionEndJob, type: :job do
  describe 'perform' do
    let(:quiz) { FactoryBot.create(:quiz) }
    let(:lobby) { FactoryBot.create(:lobby, quiz: quiz) }
    let(:question) { FactoryBot.create(:question, quiz: quiz) }

    before do
      allow(Pusher).to receive(:trigger)
    end

    subject { described_class.perform_now(lobby_id: lobby.id) }

    it 'triggers a QUESTION_END Pusher event' do
      subject

      expect(Pusher).to have_received(:trigger).with(lobby.code, Lobby::QUESTION_END, {})
    end

    it 'performs NotifyLobbyEndJob' do
      expect(NotifyLobbyEndJob).to receive(:perform_now)

      subject
    end

    context 'quiz has more questions' do
      let(:next_question) { FactoryBot.create(:question, quiz: quiz) }
      before do
        question
        next_question
      end

      it 'performs NotifyQuestionStartJob after a set wait time' do
        job_double = double(NotifyQuestionStartJob)
        expect(NotifyQuestionStartJob).to receive(:set).with(wait: Lobby::SHOW_SCORE_DELAY_SECONDS).and_return(job_double)
        expect(job_double).to receive(:perform_later).with(lobby_id: lobby.id, question_index: next_question.order)

        subject
      end
    end
  end
end
