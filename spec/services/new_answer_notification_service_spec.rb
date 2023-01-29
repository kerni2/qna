require 'rails_helper'

RSpec.describe NewAnswerNotificationService do
  let(:question) { create(:question) }
  let(:subscription) { create(:subscription, question_id: question.id) }
  let(:answer) { create(:answer, question_id: question.id) }

  it 'sends daily digests to all users' do
    question.subscriptions.each do |sub|
      expect(NewAnswerMailer).to receive(:notify).with(sub.user, answer).and_call_original
      subject.send_notification(answer)
    end
  end
end
