require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer, question_id: question.id } }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, params: { answer: { body: 'new body' }, question_id: question.id }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id } }.not_to change(Answer, :count)
      end

      it 'renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    context 'with valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question.id }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question.id }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to question page' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question.id }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question.id } }

      it 'does not change answer' do
        question.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it 'delete the answer' do
      expect { delete :destroy, params: { id: answer, question_id: question.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question page' do
      delete :destroy, params: { id: answer, question_id: question.id }
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
