require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name('User') }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'broadcasting' do
    it "matches with stream name" do
      expect {
        ActionCable.server.broadcast(
          "questions_channel", text: 'Hello!'
        )
      }.to have_broadcasted_to("questions_channel")
    end

    it "matches with message" do
      expect {
        ActionCable.server.broadcast(
          "questions_channel", text: 'Hello!'
        )
      }.to have_broadcasted_to("questions_channel").with(text: 'Hello!')
    end
  end
end
