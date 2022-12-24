require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_file, author: user) }

    before { login(user) }

    it 'deletes the file' do
      expect { delete :destroy, params: { id: question.files.first, question_id: question.id } }.to change(question.files, :count).by(-1)
    end

    it 'redirects to question page' do
      delete :destroy, params: { id: question.files.first, question_id: question.id }
      expect(response).to redirect_to question
    end
  end
end
