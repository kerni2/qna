require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question_id: question.id, author: create(:user)) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_file) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: create(:user)) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      describe 'comments' do
        let(:comment) { question.comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields of comments' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'].first }

        it 'returns list of comments' do
          expect(question_response['files'].size).to eq question.files.size
        end

        it 'returns url of file' do
          file_url = Rails.application.routes.url_helpers.rails_blob_path(question.files.first, only_path: true)
          expect(question_response['files'].first['url']).to eq file_url
        end
      end

      describe 'links' do
        let(:link) { question.links.first }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 3
        end

        it 'returns url for link' do
          expect(link_response['url']).to eq link.url
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      describe 'with valid params' do
        it 'returns status created' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
          expect(response).to have_http_status(:created)
        end

        it 'change questions count' do
          expect { post api_path,
                        params: { access_token: access_token.token, question: attributes_for(:question) },
                        headers: headers }.to change(Question, :count).by(1)
        end
      end

      describe 'with invalid params' do
        it 'returns status unprocessable_entity' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json['errors']).to be
        end

        it 'does not create question' do
          expect { post api_path,
                        params: { access_token: access_token.token, question: attributes_for(:question, :invalid) },
                        headers: headers }.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:new_question_params) { { title: 'new title', body: 'new body' } }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      describe 'when user is author' do
        let(:access_token) { create(:access_token, resource_owner_id: question.author.id) }

        describe 'with valid params' do

          it 'returns status created ' do
            patch api_path, params: { access_token: access_token.token, id: question, question: new_question_params }, headers: headers
            expect(response).to have_http_status(:created)
          end

          it 'update question with new params' do
            patch api_path, params: { access_token: access_token.token, id: question, question: new_question_params }, headers: headers
            question.reload
            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'does not change questions count' do
            expect { patch api_path,
                          params: { access_token: access_token.token, id: question, question: new_question_params },
                          headers: headers }.to_not change(Question, :count)
          end
        end

        describe 'with invalid params' do
          it 'returns status unprocessable_entity' do
            patch api_path, params: { access_token: access_token.token, id: question, question: attributes_for(:question, :invalid) }, headers: headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json['errors']).to be
          end

          it 'does not create question' do
            expect { patch api_path,
                          params: { access_token: access_token.token, id: question, question: attributes_for(:question, :invalid) },
                          headers: headers }.to_not change(Question, :count)
          end

          it 'does not update question with new params' do
            patch api_path, params: { access_token: access_token.token, id: question, question: attributes_for(:question, :invalid) }, headers: headers
            question.reload
            expect(question.title).to_not eq 'new title'
            expect(question.body).to_not eq 'new body'
          end
        end
      end

      describe 'when user is not author' do
        let(:access_token) { create(:access_token) }

        it 'returns status 403 ' do
          patch api_path, params: { access_token: access_token.token, id: question, question: new_question_params }, headers: headers
          expect(response).to have_http_status(:forbidden)
        end

        it 'does not update question with new params' do
          patch api_path, params: { access_token: access_token.token, id: question, question: new_question_params }, headers: headers
          question.reload
          expect(question.title).to_not eq 'new title'
          expect(question.body).to_not eq 'new body'
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      describe 'when user is author' do
        let(:access_token) { create(:access_token, resource_owner_id: question.author.id) }

        it 'returns status 200' do
          delete api_path, params: { access_token: access_token.token, id: question }, headers: headers
          expect(response).to have_http_status(:ok)
        end

        it 'change questions count' do
          expect { delete api_path,
                        params: { access_token: access_token.token, id: question },
                        headers: headers }.to change(Question, :count).by(-1)
        end
      end

      describe 'when user is not author' do
        let(:access_token) { create(:access_token) }

        it 'returns status 403 ' do
          patch api_path, params: { access_token: access_token.token, id: question }, headers: headers
          expect(response).to have_http_status(:forbidden)
        end

        it 'does delete question' do
          patch api_path, params: { access_token: access_token.token, id: question }, headers: headers
          expect(question).to be
        end
      end
    end
  end
end
