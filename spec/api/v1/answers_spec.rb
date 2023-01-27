require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 3, question_id: question.id) }
      let(:answer) { question.answers.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_file) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end

      describe 'comments' do
        let(:comment) { answer.comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 3
        end

        it 'returns all public fields of comments' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_response) { answer_response['files'].first }

        it 'returns list of comments' do
          expect(answer_response['files'].size).to eq answer.files.size
        end

        it 'returns url of file' do
          file_url = Rails.application.routes.url_helpers.rails_blob_path(answer.files.first, only_path: true)
          expect(answer_response['files'].first['url']).to eq file_url
        end
      end

      describe 'links' do
        let(:link) { answer.links.first }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 3
        end

        it 'returns url for link' do
          expect(link_response['url']).to eq link.url
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      describe 'with valid params' do
        it 'returns status created' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
          expect(response).to have_http_status(:created)
        end

        it 'change answers count' do
          expect { post api_path,
                        params: { access_token: access_token.token, answer: attributes_for(:answer) },
                        headers: headers }.to change(Answer, :count).by(1)
        end
      end

      describe 'with invalid params' do
        it 'returns status unprocessable_entity' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json['errors']).to be
        end

        it 'does not create answer' do
          expect { post api_path,
                        params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) },
                        headers: headers }.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:new_answer_params) { { body: 'new body' } }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      describe 'when user is author' do
        let(:access_token) { create(:access_token, resource_owner_id: answer.author.id) }

        describe 'with valid params' do

          it 'returns status created ' do
            patch api_path, params: { access_token: access_token.token, id: answer, answer: new_answer_params }, headers: headers
            expect(response).to have_http_status(:created)
          end

          it 'update question with new params' do
            patch api_path, params: { access_token: access_token.token, id: answer, answer: new_answer_params }, headers: headers
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'does not change questions count' do
            expect { patch api_path,
                          params: { access_token: access_token.token, id: answer, answer: new_answer_params },
                          headers: headers }.to_not change(Answer, :count)
          end
        end

        describe 'with invalid params' do
          it 'returns status unprocessable_entity' do
            patch api_path, params: { access_token: access_token.token, id: answer, answer: attributes_for(:answer, :invalid) }, headers: headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json['errors']).to be
          end

          it 'does not create question' do
            expect { patch api_path,
                          params: { access_token: access_token.token, id: answer, answer: attributes_for(:answer, :invalid) },
                          headers: headers }.to_not change(Answer, :count)
          end

          it 'does not update question with new params' do
            patch api_path, params: { access_token: access_token.token, id: answer, answer: attributes_for(:answer, :invalid) }, headers: headers
            answer.reload
            expect(answer.body).to_not eq 'new body'
          end
        end
      end

      describe 'when user is not author' do
        let(:access_token) { create(:access_token) }

        it 'returns status 403 ' do
          patch api_path, params: { access_token: access_token.token, id: answer, answer: new_answer_params }, headers: headers
          expect(response).to have_http_status(:forbidden)
        end

        it 'does not update answer with new params' do
          patch api_path, params: { access_token: access_token.token, id: answer, answer: new_answer_params }, headers: headers
          answer.reload
          expect(answer.body).to_not eq 'new body'
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      describe 'when user is author' do
        let(:access_token) { create(:access_token, resource_owner_id: answer.author.id) }

        it 'returns status 200' do
          delete api_path, params: { access_token: access_token.token, id: answer }, headers: headers
          expect(response).to have_http_status(:ok)
        end

        it 'change answers count' do
          expect { delete api_path,
                        params: { access_token: access_token.token, id: answer },
                        headers: headers }.to change(Answer, :count).by(-1)
        end
      end

      describe 'when user is not author' do
        let(:access_token) { create(:access_token) }

        it 'returns status 403 ' do
          patch api_path, params: { access_token: access_token.token, id: answer }, headers: headers
          expect(response).to have_http_status(:forbidden)
        end

        it 'does not delete answer' do
          patch api_path, params: { access_token: access_token.token, id: answer }, headers: headers
          expect(answer).to be
        end
      end
    end
  end
end
