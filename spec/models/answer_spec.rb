require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User') }

  it {should validate_presence_of :body}
  it { should accept_nested_attributes_for :links }

  it_behaves_like 'Votable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Linkable'

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'Broadcastable' do
    let!(:question) { create(:question) }
    let(:channel) { "question_#{question.id}" }
  end
end
