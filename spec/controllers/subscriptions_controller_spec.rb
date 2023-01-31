require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user, :confirmed) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    it 'save a new subscription in the database' do
      expect { post :create, params: {
        subscription: attributes_for(:subscription),
        question_id: question.id,
        user_id: user.id }
      }.to change(Subscription, :count).by(2)
    end

    it 'redirects to question view' do
      post :create, params: { subscription: attributes_for(:subscription), question_id: question.id, user_id: user.id }
      expect(response).to redirect_to question_path(question)
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:subscription) { create(:subscription) }

    it 'deletes the subscription' do
      expect { delete :destroy, params: { id: subscription, question_id: question.id } }.to change(Subscription, :count).by(-1)
    end

    it 'redirects to question view' do
      delete :destroy, params: { id: subscription, question_id: question.id }
      expect(response).to redirect_to question_path(question)
    end
  end
end
