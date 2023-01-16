require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
  end

  describe 'broadcasting' do
    it "matches with stream name" do
      expect {
        ActionCable.server.broadcast(
          "comments_channel", text: 'Hello!'
        )
      }.to have_broadcasted_to("comments_channel")
    end

    it "matches with message" do
      expect {
        ActionCable.server.broadcast(
          "comments_channel", text: 'Hello!'
        )
      }.to have_broadcasted_to("comments_channel").with(text: 'Hello!')
    end
  end
end
