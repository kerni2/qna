require 'rails_helper'
RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of :body }
  end
  describe 'associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
  end

  it_behaves_like 'Broadcastable' do
    let(:channel) { 'comments_channel' }
  end
end
