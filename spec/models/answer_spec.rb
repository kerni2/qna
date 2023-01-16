require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User') }

  it {should validate_presence_of :body}
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
  it { should have_many(:comments).dependent(:destroy) }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'broadcasting' do
    let!(:question) { create(:question) }

    it "matches with stream name" do
      expect {
        ActionCable.server.broadcast(
          "question_#{question.id}", text: 'Hello!'
        )
      }.to have_broadcasted_to("question_#{question.id}")
    end

    it "matches with message" do
      expect {
        ActionCable.server.broadcast(
          "question_#{question.id}", text: 'Hello!'
        )
      }.to have_broadcasted_to("question_#{question.id}").with(text: 'Hello!')
    end
  end
end
