require 'rails_helper'
RSpec.describe Question, type: :model do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :author }
  end

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:author).class_name('User') }
    it { should have_one(:reward).dependent(:destroy) }
    it { should accept_nested_attributes_for :reward }

    it_behaves_like 'Votable'
    it_behaves_like 'Commentable'
    it_behaves_like 'Linkable'

    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  it_behaves_like 'Broadcastable' do
    let(:channel) { 'questions_channel' }
  end
end
